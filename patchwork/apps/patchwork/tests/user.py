# Patchwork - automated patch tracking system
# Copyright (C) 2010 Jeremy Kerr <jk@ozlabs.org>
#
# This file is part of the Patchwork package.
#
# Patchwork is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# Patchwork is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Patchwork; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

import unittest
from django.test import TestCase
from django.test.client import Client
from django.core import mail
from django.core.urlresolvers import reverse
from django.conf import settings
from django.contrib.auth.models import User
from patchwork.models import EmailConfirmation, Person

def _confirmation_url(conf):
    return reverse('patchwork.views.confirm', kwargs = {'key': conf.key})

class TestUser(object):
    username = 'testuser'
    email = 'test@example.com'
    secondary_email = 'test2@example.com'
    password = None

    def __init__(self):
        self.password = User.objects.make_random_password()
        self.user = User.objects.create_user(self.username,
                            self.email, self.password)

class UserPersonRequestTest(TestCase):
    def setUp(self):
        self.user = TestUser()
        self.client.login(username = self.user.username,
                          password = self.user.password)
        EmailConfirmation.objects.all().delete()

    def testUserPersonRequestForm(self):
        response = self.client.get('/user/link/')
        self.assertEquals(response.status_code, 200)
        self.assertTrue(response.context['linkform'])

    def testUserPersonRequestEmpty(self):
        response = self.client.post('/user/link/', {'email': ''})
        self.assertEquals(response.status_code, 200)
        self.assertTrue(response.context['linkform'])
        self.assertFormError(response, 'linkform', 'email',
                'This field is required.')

    def testUserPersonRequestInvalid(self):
        response = self.client.post('/user/link/', {'email': 'foo'})
        self.assertEquals(response.status_code, 200)
        self.assertTrue(response.context['linkform'])
        self.assertFormError(response, 'linkform', 'email',
                'Enter a valid e-mail address.')

    def testUserPersonRequestValid(self):
        response = self.client.post('/user/link/',
                                {'email': self.user.secondary_email})
        self.assertEquals(response.status_code, 200)
        self.assertTrue(response.context['confirmation'])

        # check that we have a confirmation saved
        self.assertEquals(EmailConfirmation.objects.count(), 1)
        conf = EmailConfirmation.objects.all()[0]
        self.assertEquals(conf.user, self.user.user)
        self.assertEquals(conf.email, self.user.secondary_email)
        self.assertEquals(conf.type, 'userperson')

        # check that an email has gone out...
        self.assertEquals(len(mail.outbox), 1)
        msg = mail.outbox[0]
        self.assertEquals(msg.subject, 'Patchwork email address confirmation')
        self.assertTrue(self.user.secondary_email in msg.to)
        self.assertTrue(_confirmation_url(conf) in msg.body)

        # ...and that the URL is valid
        response = self.client.get(_confirmation_url(conf))
        self.assertEquals(response.status_code, 200)
        self.assertTemplateUsed(response, 'patchwork/user-link-confirm.html')

class UserPersonConfirmTest(TestCase):
    def setUp(self):
        EmailConfirmation.objects.all().delete()
        Person.objects.all().delete()
        self.user = TestUser()
        self.client.login(username = self.user.username,
                          password = self.user.password)
        self.conf = EmailConfirmation(type = 'userperson',
                                      email = self.user.secondary_email,
                                      user = self.user.user)
        self.conf.save()

    def testUserPersonConfirm(self):
        self.assertEquals(Person.objects.count(), 1)
        response = self.client.get(_confirmation_url(self.conf))
        self.assertEquals(response.status_code, 200)

        # check that the Person object has been created and linked
        self.assertEquals(Person.objects.count(), 2)
        person = Person.objects.get(email = self.user.secondary_email)
        self.assertEquals(person.email, self.user.secondary_email)
        self.assertEquals(person.user, self.user.user)

        # check that the confirmation has been marked as inactive. We
        # need to reload the confirmation to check this.
        conf = EmailConfirmation.objects.get(pk = self.conf.pk)
        self.assertEquals(conf.active, False)

class UserLoginRedirectTest(TestCase):
    
    def testUserLoginRedirect(self):
        url = '/user/'
        response = self.client.get(url)
        self.assertRedirects(response, settings.LOGIN_URL + '?next=' + url)


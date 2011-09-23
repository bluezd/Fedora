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
import re
from django.test import TestCase
from django.test.client import Client
from django.core import mail
from django.core.urlresolvers import reverse
from django.contrib.auth.models import User
from patchwork.models import EmailOptout, EmailConfirmation, Person
from patchwork.tests.utils import create_user

class MailSettingsTest(TestCase):
    view = 'patchwork.views.mail.settings'
    url = reverse(view)

    def testMailSettingsGET(self):
        response = self.client.get(self.url)
        self.assertEquals(response.status_code, 200)
        self.assertTrue(response.context['form'])

    def testMailSettingsPOST(self):
        email = u'foo@example.com'
        response = self.client.post(self.url, {'email': email})
        self.assertEquals(response.status_code, 200)
        self.assertTemplateUsed(response, 'patchwork/mail-settings.html')
        self.assertEquals(response.context['email'], email)

    def testMailSettingsPOSTEmpty(self):
        response = self.client.post(self.url, {'email': ''})
        self.assertEquals(response.status_code, 200)
        self.assertTemplateUsed(response, 'patchwork/mail-form.html')
        self.assertFormError(response, 'form', 'email',
                'This field is required.')

    def testMailSettingsPOSTInvalid(self):
        response = self.client.post(self.url, {'email': 'foo'})
        self.assertEquals(response.status_code, 200)
        self.assertTemplateUsed(response, 'patchwork/mail-form.html')
        self.assertFormError(response, 'form', 'email',
                'Enter a valid e-mail address.')

    def testMailSettingsPOSTOptedIn(self):
        email = u'foo@example.com'
        response = self.client.post(self.url, {'email': email})
        self.assertEquals(response.status_code, 200)
        self.assertTemplateUsed(response, 'patchwork/mail-settings.html')
        self.assertEquals(response.context['is_optout'], False)
        self.assertTrue('<strong>may</strong>' in response.content)
        optout_url = reverse('patchwork.views.mail.optout')
        self.assertTrue(('action="%s"' % optout_url) in response.content)

    def testMailSettingsPOSTOptedOut(self):
        email = u'foo@example.com'
        EmailOptout(email = email).save()
        response = self.client.post(self.url, {'email': email})
        self.assertEquals(response.status_code, 200)
        self.assertTemplateUsed(response, 'patchwork/mail-settings.html')
        self.assertEquals(response.context['is_optout'], True)
        self.assertTrue('<strong>may not</strong>' in response.content)
        optin_url = reverse('patchwork.views.mail.optin')
        self.assertTrue(('action="%s"' % optin_url) in response.content)

class OptoutRequestTest(TestCase):
    view = 'patchwork.views.mail.optout'
    url = reverse(view)

    def testOptOutRequestGET(self):
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('patchwork.views.mail.settings'))

    def testOptoutRequestValidPOST(self):
        email = u'foo@example.com'
        response = self.client.post(self.url, {'email': email})

        # check for a confirmation object
        self.assertEquals(EmailConfirmation.objects.count(), 1)
        conf = EmailConfirmation.objects.get(email = email)

        # check confirmation page
        self.assertEquals(response.status_code, 200)
        self.assertEquals(response.context['confirmation'], conf)
        self.assertTrue(email in response.content)

        # check email
        url = reverse('patchwork.views.confirm', kwargs = {'key': conf.key})
        self.assertEquals(len(mail.outbox), 1)
        msg = mail.outbox[0]
        self.assertEquals(msg.to, [email])
        self.assertEquals(msg.subject, 'Patchwork opt-out confirmation')
        self.assertTrue(url in msg.body)

    def testOptoutRequestInvalidPOSTEmpty(self):
        response = self.client.post(self.url, {'email': ''})
        self.assertEquals(response.status_code, 200)
        self.assertFormError(response, 'form', 'email',
                'This field is required.')
        self.assertTrue(response.context['error'])
        self.assertTrue('email_sent' not in response.context)
        self.assertEquals(len(mail.outbox), 0)

    def testOptoutRequestInvalidPOSTNonEmail(self):
        response = self.client.post(self.url, {'email': 'foo'})
        self.assertEquals(response.status_code, 200)
        self.assertFormError(response, 'form', 'email',
                'Enter a valid e-mail address.')
        self.assertTrue(response.context['error'])
        self.assertTrue('email_sent' not in response.context)
        self.assertEquals(len(mail.outbox), 0)

class OptoutTest(TestCase):
    view = 'patchwork.views.mail.optout'
    url = reverse(view)

    def setUp(self):
        self.email = u'foo@example.com'
        self.conf = EmailConfirmation(type = 'optout', email = self.email)
        self.conf.save()

    def testOptoutValidHash(self):
        url = reverse('patchwork.views.confirm',
                        kwargs = {'key': self.conf.key})
        response = self.client.get(url)

        self.assertEquals(response.status_code, 200)
        self.assertTemplateUsed(response, 'patchwork/optout.html')
        self.assertTrue(self.email in response.content)

        # check that we've got an optout in the list
        self.assertEquals(EmailOptout.objects.count(), 1)
        self.assertEquals(EmailOptout.objects.all()[0].email, self.email)

        # check that the confirmation is now inactive
        self.assertFalse(EmailConfirmation.objects.get(
                                    pk = self.conf.pk).active)


class OptoutPreexistingTest(OptoutTest):
    """Test that a duplicated opt-out behaves the same as the initial one"""
    def setUp(self):
        super(OptoutPreexistingTest, self).setUp()
        EmailOptout(email = self.email).save()

class OptinRequestTest(TestCase):
    view = 'patchwork.views.mail.optin'
    url = reverse(view)

    def setUp(self):
        self.email = u'foo@example.com'
        EmailOptout(email = self.email).save()

    def testOptInRequestGET(self):
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('patchwork.views.mail.settings'))

    def testOptInRequestValidPOST(self):
        response = self.client.post(self.url, {'email': self.email})

        # check for a confirmation object
        self.assertEquals(EmailConfirmation.objects.count(), 1)
        conf = EmailConfirmation.objects.get(email = self.email)

        # check confirmation page
        self.assertEquals(response.status_code, 200)
        self.assertEquals(response.context['confirmation'], conf)
        self.assertTrue(self.email in response.content)

        # check email
        url = reverse('patchwork.views.confirm', kwargs = {'key': conf.key})
        self.assertEquals(len(mail.outbox), 1)
        msg = mail.outbox[0]
        self.assertEquals(msg.to, [self.email])
        self.assertEquals(msg.subject, 'Patchwork opt-in confirmation')
        self.assertTrue(url in msg.body)

    def testOptoutRequestInvalidPOSTEmpty(self):
        response = self.client.post(self.url, {'email': ''})
        self.assertEquals(response.status_code, 200)
        self.assertFormError(response, 'form', 'email',
                'This field is required.')
        self.assertTrue(response.context['error'])
        self.assertTrue('email_sent' not in response.context)
        self.assertEquals(len(mail.outbox), 0)

    def testOptoutRequestInvalidPOSTNonEmail(self):
        response = self.client.post(self.url, {'email': 'foo'})
        self.assertEquals(response.status_code, 200)
        self.assertFormError(response, 'form', 'email',
                'Enter a valid e-mail address.')
        self.assertTrue(response.context['error'])
        self.assertTrue('email_sent' not in response.context)
        self.assertEquals(len(mail.outbox), 0)

class OptinTest(TestCase):

    def setUp(self):
        self.email = u'foo@example.com'
        self.optout = EmailOptout(email = self.email)
        self.optout.save()
        self.conf = EmailConfirmation(type = 'optin', email = self.email)
        self.conf.save()

    def testOptinValidHash(self):
        url = reverse('patchwork.views.confirm',
                        kwargs = {'key': self.conf.key})
        response = self.client.get(url)

        self.assertEquals(response.status_code, 200)
        self.assertTemplateUsed(response, 'patchwork/optin.html')
        self.assertTrue(self.email in response.content)

        # check that there's no optout remaining
        self.assertEquals(EmailOptout.objects.count(), 0)

        # check that the confirmation is now inactive
        self.assertFalse(EmailConfirmation.objects.get(
                                    pk = self.conf.pk).active)

class OptinWithoutOptoutTest(TestCase):
    """Test an opt-in with no existing opt-out"""
    view = 'patchwork.views.mail.optin'
    url = reverse(view)

    def testOptInWithoutOptout(self):
        email = u'foo@example.com'
        response = self.client.post(self.url, {'email': email})

        # check for an error message
        self.assertEquals(response.status_code, 200)
        self.assertTrue(bool(response.context['error']))
        self.assertTrue('not on the patchwork opt-out list' in response.content)

class UserProfileOptoutFormTest(TestCase):
    """Test that the correct optin/optout forms appear on the user profile
       page, for logged-in users"""

    view = 'patchwork.views.user.profile'
    url = reverse(view)
    optout_url = reverse('patchwork.views.mail.optout')
    optin_url = reverse('patchwork.views.mail.optin')
    form_re_template = ('<form\s+[^>]*action="%(url)s"[^>]*>'
                        '.*?<input\s+[^>]*value="%(email)s"[^>]*>.*?'
                        '</form>')
    secondary_email = 'test2@example.com'

    def setUp(self):
        self.user = create_user()
        self.client.login(username = self.user.username,
                password = self.user.username)

    def _form_re(self, url, email):
        return re.compile(self.form_re_template % {'url': url, 'email': email},
                          re.DOTALL)

    def testMainEmailOptoutForm(self):
        form_re = self._form_re(self.optout_url, self.user.email)
        response = self.client.get(self.url)
        self.assertEquals(response.status_code, 200)
        self.assertTrue(form_re.search(response.content) is not None)

    def testMainEmailOptinForm(self):
        EmailOptout(email = self.user.email).save()
        form_re = self._form_re(self.optin_url, self.user.email)
        response = self.client.get(self.url)
        self.assertEquals(response.status_code, 200)
        self.assertTrue(form_re.search(response.content) is not None)

    def testSecondaryEmailOptoutForm(self):
        p = Person(email = self.secondary_email, user = self.user)
        p.save()
        
        form_re = self._form_re(self.optout_url, p.email)
        response = self.client.get(self.url)
        self.assertEquals(response.status_code, 200)
        self.assertTrue(form_re.search(response.content) is not None)

    def testSecondaryEmailOptinForm(self):
        p = Person(email = self.secondary_email, user = self.user)
        p.save()
        EmailOptout(email = p.email).save()

        form_re = self._form_re(self.optin_url, self.user.email)
        response = self.client.get(self.url)
        self.assertEquals(response.status_code, 200)
        self.assertTrue(form_re.search(response.content) is not None)

# Patchwork - automated patch tracking system
# Copyright (C) 2009 Jeremy Kerr <jk@ozlabs.org>
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
from patchwork.models import Patch, Comment, Person
from patchwork.tests.utils import defaults, create_user, find_in_context

class MboxPatchResponseTest(TestCase):
    """ Test that the mbox view appends the Acked-by from a patch comment """
    def setUp(self):
        defaults.project.save()

        self.person = defaults.patch_author_person
        self.person.save()

        self.patch = Patch(project = defaults.project,
                           msgid = 'p1', name = 'testpatch',
                           submitter = self.person, content = '')
        self.patch.save()
        comment = Comment(patch = self.patch, msgid = 'p1',
                submitter = self.person,
                content = 'comment 1 text\nAcked-by: 1\n')
        comment.save()

        comment = Comment(patch = self.patch, msgid = 'p2',
                submitter = self.person,
                content = 'comment 2 text\nAcked-by: 2\n')
        comment.save()

    def testPatchResponse(self):
        response = self.client.get('/patch/%d/mbox/' % self.patch.id)
        self.assertContains(response,
                'Acked-by: 1\nAcked-by: 2\n')

class MboxPatchSplitResponseTest(TestCase):
    """ Test that the mbox view appends the Acked-by from a patch comment,
        and places it before an '---' update line. """
    def setUp(self):
        defaults.project.save()

        self.person = defaults.patch_author_person
        self.person.save()

        self.patch = Patch(project = defaults.project,
                           msgid = 'p1', name = 'testpatch',
                           submitter = self.person, content = '')
        self.patch.save()
        comment = Comment(patch = self.patch, msgid = 'p1',
                submitter = self.person,
                content = 'comment 1 text\nAcked-by: 1\n---\nupdate\n')
        comment.save()

        comment = Comment(patch = self.patch, msgid = 'p2',
                submitter = self.person,
                content = 'comment 2 text\nAcked-by: 2\n')
        comment.save()

    def testPatchResponse(self):
        response = self.client.get('/patch/%d/mbox/' % self.patch.id)
        self.assertContains(response,
                'Acked-by: 1\nAcked-by: 2\n')

class MboxPassThroughHeaderTest(TestCase):
    """ Test that we see 'Cc' and 'To' headers passed through from original
        message to mbox view """

    def setUp(self):
        defaults.project.save()
        self.person = defaults.patch_author_person
        self.person.save()

        self.cc_header = 'Cc: CC Person <cc@example.com>'
        self.to_header = 'To: To Person <to@example.com>'

        self.patch = Patch(project = defaults.project,
                           msgid = 'p1', name = 'testpatch',
                           submitter = self.person, content = '')

    def testCCHeader(self):
        self.patch.headers = self.cc_header + '\n'
        self.patch.save()

        response = self.client.get('/patch/%d/mbox/' % self.patch.id)
        self.assertContains(response, self.cc_header)

    def testToHeader(self):
        self.patch.headers = self.to_header + '\n'
        self.patch.save()

        response = self.client.get('/patch/%d/mbox/' % self.patch.id)
        self.assertContains(response, self.to_header)

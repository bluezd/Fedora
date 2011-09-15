# Copyright (C) 2009, 2010  Roman Zimbelmann <romanz@lavabit.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

"""
This is the default ranger configuration file for filetype detection
and application handling.

You can place this file in your ~/.ranger/ directory and it will be used
instead of this one.  Though, to minimize your effort when upgrading ranger,
you may want to subclass CustomApplications rather than making a full copy.
                       
This example modifies the behaviour of "feh" and adds a custom media player:

#### start of the ~/.ranger/apps.py example
        from ranger.defaults.apps import CustomApplications as DefaultApps
        from ranger.api.apps import *
                       
        class CustomApplications(DefaultApps):
                def app_kaffeine(self, c):
                        return tup('kaffeine', *c)

                def app_feh_fullscreen_by_default(self, c):
                        return tup('feh', '-F', *c)

                def app_default(self, c):
                        f = c.file #shortcut
                        if f.video or f.audio:
                                return self.app_kaffeine(c)

                        if f.image and c.mode == 0:
                                return self.app_feh_fullscreen_by_default(c)

                        return DefaultApps.app_default(self, c)
#### end of the example
"""

from ranger.api.apps import *
from ranger.ext.get_executables import get_executables

class CustomApplications(Applications):
        def app_default(self, c):
                """How to determine the default application?"""
                f = c.file

                if f.basename.lower() == 'makefile':
                        return self.app_make(c)

                if f.extension is not None:
                        if f.extension in ('pdf', ):
                                c.flags += 'd'
                                return self.either(c, 'evince')
                        if f.extension in ('xml', ):
                                return self.app_editor(c)
                        if f.extension in ('html', 'htm', 'xhtml'):
                                return self.app_editor(c)
                        if f.extension in ('swf', ):
                                return self.either(c, 'firefox')
                        if f.extension == 'nes':
                                return self.app_fceux(c)
                        if f.extension in ('swc', 'smc'):
                                return self.app_zsnes(c)

                if f.mimetype is not None:
                        if INTERPRETED_LANGUAGES.match(f.mimetype):
                                return self.app_edit_or_run(c)

                if f.container:
                        return self.app_aunpack(c)

                if f.video or f.audio:
                        if f.video:
                                c.flags += 'd'
                        return self.either(c, 'mplayer')

                if f.image:
                        c.flags += 'd'
                        return self.either(c, 'gqview')

                if f.document or f.filetype.startswith('text'):
                        return self.app_editor(c)


        # ----------------------------------------- application definitions
        # Note: Trivial applications are defined at the bottom
        def app_pager(self, c):
                return tup('less', *c)

        def app_editor(self, c):
                try:
                        default_editor = os.environ['EDITOR']
                except KeyError:
                        pass
                else:
                        parts = default_editor.split()
                        exe_name = os.path.basename(parts[0])
                        if exe_name in get_executables():
                                return tuple(parts) + tuple(c)

                return self.either(c, 'vim', 'emacs', 'nano')

        @depends_on(app_editor, Applications.app_self)
        def app_edit_or_run(self, c):
                if c.mode is 1:
                        return self.app_self(c)
                return self.app_editor(c)

        @depends_on('mplayer')
        def app_mplayer(self, c):
                if c.mode is 1:
                        return tup('mplayer', '-fs', *c)

                elif c.mode is 2:
                        args = "mplayer -fs -sid 0 -vfm ffmpeg -lavdopts " \
                                        "lowres=1:fast:skiploopfilter=all:threads=8".split()
                        args.extend(c)
                        return tup(*args)

                elif c.mode is 3:
                        return tup('mplayer', '-mixer', 'software', *c)

                else:
                        return tup('mplayer', *c)

        @depends_on('aunpack')
        def app_aunpack(self, c):
                if c.mode is 0:
                        c.flags += 'p'
                        return tup('aunpack', '-l', c.file.path)
                return tup('aunpack', c.file.path)

        @depends_on('make')
        def app_make(self, c):
                if c.mode is 0:
                        return tup("make")
                if c.mode is 1:
                        return tup("make", "install")
                if c.mode is 2:
                        return tup("make", "clear")

        @depends_on('java')
        def app_java(self, c):
                def strip_extensions(file):
                        if '.' in file.basename:
                                return file.path[:file.path.index('.')]
                        return file.path
                files_without_extensions = map(strip_extensions, c.files)
                return tup("java", files_without_extensions)

        @depends_on('gqview')
        def app_gqview(self, c):
                return tup("gqview", *c)


# Often a programs invocation is trivial.  For example:
#       vim test.py readme.txt [...]
# This could be implemented like:
#       @depends_on("vim")
#       def app_vim(self, c):
#               return tup("vim", *c.files)
# Instead of creating such a generic function for each program, just add
# its name here and it will be automatically done for you.
#CustomApplications.generic('vim', 'fceux', 'elinks', 'wine',
                #'zsnes', 'javac')

# By setting flags='d', this programs will not block ranger's terminal:
#CustomApplications.gqview('gqview', flags='d')

# What filetypes are recognized as scripts for interpreted languages?
# This regular expression is used in app_default()
INTERPRETED_LANGUAGES = re.compile(r'''
        ^(text|application)/x-(
                haskell|perl|python|ruby|sh
        )$''', re.VERBOSE)
 

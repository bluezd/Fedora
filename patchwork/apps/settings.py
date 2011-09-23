# Django settings for patchwork project.
import os

DEBUG = True
TEMPLATE_DEBUG = DEBUG

ADMINS = (
     ('Jeremy Kerr', 'jk@ozlabs.org'),
)

MANAGERS = ADMINS

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'patchwork',
    },
}

# Local time zone for this installation. Choices can be found here:
# http://www.postgresql.org/docs/8.1/static/datetime-keywords.html#DATETIME-TIMEZONE-SET-TABLE
# although not all variations may be possible on all operating systems.
# If running in a Windows environment this must be set to the same as your
# system time zone.
TIME_ZONE = 'Australia/Canberra'

# Language code for this installation. All choices can be found here:
# http://www.w3.org/TR/REC-html40/struct/dirlang.html#langcodes
# http://blogs.law.harvard.edu/tech/stories/storyReader$15
LANGUAGE_CODE = 'en-au'

SITE_ID = 1

# If you set this to False, Django will make some optimizations so as not
# to load the internationalization machinery.
USE_I18N = True

# URL that handles the media served from MEDIA_ROOT.
# Example: "http://media.lawrence.com"
MEDIA_URL = ''

# URL prefix for admin media -- CSS, JavaScript and images. Make sure to use a
# trailing slash.
# Examples: "http://foo.com/media/", "/media/".
ADMIN_MEDIA_PREFIX = '/media/'

# Make this unique, and don't share it with anybody.
SECRET_KEY = '00000000000000000000000000000000000000000000000000'

# List of callables that know how to import templates from various sources.
TEMPLATE_LOADERS = (
    'django.template.loaders.filesystem.load_template_source',
    'django.template.loaders.app_directories.load_template_source',
#     'django.template.loaders.eggs.load_template_source',
)

MIDDLEWARE_CLASSES = (
    'django.middleware.common.CommonMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.middleware.doc.XViewMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
)

ROOT_URLCONF = 'apps.urls'

LOGIN_URL = '/user/login/'
LOGIN_REDIRECT_URL = '/user/'

# If you change the ROOT_DIR setting in your local_settings.py, you'll need to
# re-define the variables that use this (MEDIA_ROOT and TEMPLATE_DIRS) too.
ROOT_DIR = '/srv/patchwork'
TEMPLATE_DIRS = (
    # Put strings here, like "/home/html/django_templates" or "C:/www/django/templates".
    # Always use forward slashes, even on Windows.
    # Don't forget to use absolute paths, not relative paths.
    os.path.join(ROOT_DIR, 'templates')
)
# Absolute path to the directory that holds media.
# Example: "/home/media/media.lawrence.com/"
MEDIA_ROOT = os.path.join(
    ROOT_DIR, 'lib', 'python', 'django', 'contrib', 'admin', 'media')

TEMPLATE_CONTEXT_PROCESSORS = (
    "django.core.context_processors.auth",
    "django.core.context_processors.debug",
    "django.core.context_processors.i18n",
    "django.core.context_processors.media")

AUTH_PROFILE_MODULE = "patchwork.userprofile"

INSTALLED_APPS = (
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.sites',
    'django.contrib.admin',
    'patchwork',
)

DEFAULT_PATCHES_PER_PAGE = 100
DEFAULT_FROM_EMAIL = 'Patchwork <patchwork@patchwork.example.com>'

CONFIRMATION_VALIDITY_DAYS = 7

NOTIFICATION_DELAY_MINUTES = 10
NOTIFICATION_FROM_EMAIL = DEFAULT_FROM_EMAIL

# Set to True to enable the Patchwork XML-RPC interface
ENABLE_XMLRPC = False

try:
    from local_settings import *
except ImportError, ex:
    import sys
    sys.stderr.write(\
            ("settings.py: error importing local settings file:\n" + \
            "\t%s\n" + \
            "Do you have a local_settings.py module?\n") % str(ex))
    raise

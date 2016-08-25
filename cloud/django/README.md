# security in template
@csrf_exempt

# paginator
from django.core.paginator import Paginator

# cache memcached
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
        'LOCATION': [
            '127.0.0.1:11211',
            '172.19.26.240:11211',
            '172.19.26.242:11211',
        ]
    }
}

# cache database
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.db.DatabaseCache',
        'LOCATION': 'my_cache_table',
    }
}
python manage.py createcachetable


# for apps
python manage.py migrate
python manage.py collectstatic


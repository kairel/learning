from __future__ import (absolute_import, division, print_function)
__metaclass__ = type


def split_ip(value):
    return value.split(".")


class FilterModule(object):

    def filters(self):
        return {
            'split_ip': split_ip
        }

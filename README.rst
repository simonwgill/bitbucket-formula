======
bitbucket
======

Formulas to set up and configure Atlassian BitBucket.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``bitbucket``
----------

Installs the bitbucket standalone tarball and starts the service.  Configures
~bitbucket/dbconfig.xml, but assumes database creation handled by another forumla
(e.g. postgres-formula).  

``bitbucket.proxy``
------------------

Enables a basic Apache proxy for bitbucket. This currently requires https://github.com/simonwgill/apacheproxy-formula

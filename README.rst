
=======
Libvirt
=======

Sample pillars
==============

simple libvirt server


.. code-block:: yaml

    libvirt:
      server:
        enabled: true
        unix_sock_group: libvirt
        virtualizations:
        - kvm
        network:
          default:
            ensure: absent

.. code-block:: yaml

    libvirt:
      server:
        enabled: true
        network:
          default:
            ensure: absent #present, running, stopped, absent
          mydefault:
            xml: |
              <network>
                <name>mydefault</name>
                <bridge name="virbr0"/>
                <forward/>
                <ip address="192.168.122.1" netmask="255.255.255.0">
                  <dhcp>
                    <range start="192.168.122.2" end="192.168.122.254"/>
                  </dhcp>
                </ip>
              </network>
          ovs-net:
            autostart: False
            xml: |
              <network>
                <name>ovs-net</name>
                <forward mode='bridge'/>
                <bridge name='ovsbr0'/>
                <virtualport type='openvswitch'>
                  <parameters interfaceid='09b11c53-8b5c-4eeb-8f00-d84eaa0aaa4f'/>
                </virtualport>
              </network>

.. code-block:: yaml

    libvirt:
      server:
        enabled: true
        pool:
          virtimages:
            type: dir
            path: /var/lib/libvirt/images
            xml: |
              <pool type="dir">
                <name>virtimages</name>
                  <target>
                    <path>/var/lib/libvirt/images</path>
                  </target>
              </pool>
          virtimages2:
            ensure: absent
            type: dir
            path: /var/lib/libvirt/images2
            xml: |
              <pool type="dir">
                <name>virtimages2</name>
                  <target>
                    <path>/var/lib/libvirt/images2</path>
                  </target>
              </pool>

Read more
=========

* https://github.com/bechtoldt/saltstack-libvirt-formula
Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-libvirt/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

You can also join salt-formulas-users team and subscribe to mailing list:

    https://launchpad.net/~salt-formulas-users

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

    https://github.com/salt-formulas/salt-formula-libvirt

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net

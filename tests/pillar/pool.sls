libvirt:
  server:
    enabled: true
    virtualizations:
    - kvm
    network:
      default:
        ensure: absent
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
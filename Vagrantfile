Vagrant.configure("2") do |config|
  config.vm.define :ctfbox do |ctfbox|
    ctfbox.vm.box = "archlinux/archlinux"
    ctfbox.vm.provision :shell, path: "bootstrap.sh"
    # maybe add a synced folder... if you DARE!!
    # ctfbox.vm.synced_folder "~/ctfs", "~/ctfs", type: "nfs"

    # maybe forward a port.... for INSTANT DEATH!!!1! 
    # ctfbox.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

    # maybe use Virtualbox... If you WANT TO!!!!! 
    # ctfbox.vm.provider :virtualbox do |vb|
    #   vb.cpus = 2
    #   vb.memory = 8192
    # end
    
    ctfbox.vm.provider :libvirt do |lv|
      # for custom storage pool
      # lv.storage_pool_name = "pool-2"
      
      lv.cpus = 2
      lv.memory = 8192
      
      # For graffix and clipboard sharing
      lv.graphics_type = "spice"
      lv.video_type = "qxl"
      lv.channel :type => "spicevmc", :target_name => "com.redhat.spice.0", :target_type => "virtio"
    end
  end
end

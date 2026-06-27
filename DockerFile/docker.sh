
docker run -itd  \
--name=pxe-install-os --net=host  --device /dev/fuse    \
--cap-add SYS_ADMIN   --privileged=true         \
-p 67-90:67-90                                 \
-v /opt/pxe/tftpboot:/var/lib/tftpboot/            \
-v /opt/pxe/web:/var/www/html/                  \
-v /opt/pxe/dhcp:/etc/dhcp/                    \
-e local_ip=192.168.10.128                      \
-e next_ip=192.168.10.128                       \
-e subnet=192.168.10.0                        \
-e netmask=255.255.255.0                       \
-e gateway=192.168.10.128                        \
-e nameserver=192.168.10.128                    \
-e range_start="192.168.10.100"                  \
-e range_end="192.168.10.200"                    \
-e iso_label=ol24_Install                      \
-v /root/openEuler-24.03-LTS-SP3-x86_64-dvd.iso:/iso/path.iso                  \
pxe_uefi_install_0605:v1 


#####参数解析
## -v /opt/pxe/tftpboot:/var/lib/tftpboot/   将容器内tftp目录挂载到宿主机,可验证是否有镜像引导文件
## -v /opt/pxe/web:/var/www/html/            将容器内web[http]目录挂载到宿主机,后期可自定义修改KS文件内容
## -v /opt/pxe/dhcp:/etc/dhcp/               将容器内DHCP目录挂载到宿主机,可自定义修改dhcpd.conf文件内容
## -e local_ip=192.168.10.128                宿主机IP地址  
## -e next_ip=192.168.10.128                 宿主机IP地址  
## -e subnet=192.168.10.0                    客户端IP网段[和宿主机网段一致]  
## -e netmask=255.255.255.0                  客户端IP掩码[不可简写]  
## -e gateway=192.168.10.128                 客户端IP网关[可设置宿主机IP]  
## -e nameserver=192.168.10.128              客户端IP域名解析[可设置宿主机IP]  
## -e range_start="192.168.10.100"           客户端IP地址分配范围[起点IP]  
## -e range_end="192.168.10.200"             客户端IP地址分配范围[结束IP]  
## -e iso_label=ol24_Install                 引导菜单栏label[label_name]   
## -v /root/openEuler-24.03-LTS-SP3-x86_64-dvd.iso:/iso/path.iso   提供客户端系统镜像地址[:后面路径请勿修改]                 

##
##
##
##





sleep 2
echo 
echo 
docker logs -f  pxe-install-os

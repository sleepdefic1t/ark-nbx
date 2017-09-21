echo "Stopping ArkBox..."
sudo /etc/init.d/arkbox stop
echo "Removing ArkBox daemon..."
sudo update-rc.d arkbox remove 
sudo rm -v /etc/init.d/arkbox
echo "Removing ArkBox folder..."
sudo rm -rf -v /opt/arkbox
iso_name='ubuntu-24.04.4-live-server-amd64.iso'
path_iso='/var/lib/vz/template/iso'
workdir="$path_iso/source-files"

# Очистка
rm -rf "$workdir"
mkdir -p "$workdir"

# Распаковка ISO
xorriso -osirrox on \
  -indev "$path_iso/$iso_name" \
  --extract_boot_images "$workdir/bootpart" \
  -extract / "$workdir"

# Добавляем nocloud
cp -r /root/nocloud "$workdir/"

# Меняем grub на кастомный
cp -v /root/control-node/grub.cfg /var/lib/vz/template/iso/source-files/boot/grub/grub.cfg

# Переход в папку
cd "$workdir" || exit 1

# Сборка
xorriso -as mkisofs \
  -r \
  -V "Ubuntu-autoinstall" \
  -J \
  -boot-load-size 4 \
  -boot-info-table \
  -input-charset utf-8 \
  -eltorito-alt-boot \
  -b bootpart/eltorito_img1_bios.img \
  -no-emul-boot \
  -o "$path_iso/installer.iso" \
  .
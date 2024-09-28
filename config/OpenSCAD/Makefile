OpenSCAD-x86_64.AppImage:
	./OpenSCAD-*-x86_64.AppImage --appimage-extract
	mkdir -p squashfs-root/usr/plugins/styles
	cp /usr/lib/qt/plugins/platformthemes/libqt5ct.so squashfs-root/usr/plugins/platformthemes/
	cp /usr/lib/qt/plugins/styles/libqt5ct-style.so squashfs-root/usr/plugins/styles/
	appimagetool squashfs-root

install: OpenSCAD-x86_64.AppImage
	mv OpenSCAD-x86_64.AppImage ~/.local/bin/openscad

clean:
	$(RM) -r squashfs-root/

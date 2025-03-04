ListTile(
  title: Text('เปลี่ยนสี AppBar'),
  onTap: () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('เลือกสี AppBar'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: context.read<ThemeProvider>().appBarColor,
            onColorChanged: (color) {
              context.read<ThemeProvider>().updateAppBarColor(color);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ตกลง'),
          ),
        ],
      ),
    );
  },
), 
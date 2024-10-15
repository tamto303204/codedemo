contact = {"Trung": "0382218642", "Huyen":"0869661807", "Hung":"0374454750", "Hanh":"0862115687"}
print("Ten trong danh ba: ")
for key in contact.keys():
    print(f"{key}")
print("Cac so dien thoai: ")
for value in contact.values():
    print(f"{value}")
print("Danh ba dien thoai: ")
for key, value in contact.items():
    print(f"{key} - {value}")
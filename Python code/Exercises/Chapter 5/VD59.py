student = {
    "name":"Dang Thanh Trung",
    "id":"86868686",
    "mark":{"java":10,"python":9,"c++":9},
    "language":{"english":"good", "french":"fair"}
}
print(f"Student id: {student['id']}")
print(f"Student name: {student['name']}")
print("Subject mark: ")
for s,d in student["mark"].items():
    print(f"\t {s} : {d}")
dtb = sum(student["mark"].values()) / len(student["mark"])
print(f"Diem TBL {dtb}")
print("Language: ")
for l,s in student["language"].items():
    print(f"\t {l} : {s}")
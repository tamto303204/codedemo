import turtle

# Thiết lập cửa sổ vẽ
turtle.bgcolor("white")
turtle.setup(width=800, height=800)

# Tạo đối tượng bút vẽ
pen = turtle.Pen()
pen.pensize(12)
pen.color("red")
pen.speed(1)

# Bắt đầu lấp đầy màu cho hình trái tim
pen.fillcolor("red")
pen.begin_fill()

# Vẽ hình trái tim
pen.left(50)
pen.forward(133)
pen.circle(50, 200)
pen.right(140)
pen.circle(50, 200)
pen.forward(133)

# Kết thúc quá trình lấp đầy
pen.end_fill()

# Ẩn bút vẽ sau khi vẽ xong
pen.hideturtle()

# Giữ cửa sổ vẽ mở
turtle.done()

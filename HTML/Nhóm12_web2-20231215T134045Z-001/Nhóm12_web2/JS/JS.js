/*Doi mau thanh*/
window.addEventListener('scroll', function () {
  var navbar = document.querySelector('.navbar');
  var menu = document.querySelector('.header-menu');
  var scrolled = document.documentElement.scrollTop;

  if (scrolled > 450) { //cuon xuong doi mau header
    navbar.classList.add('scrolled');
    menu.classList.add('scrolled');
  } else {
    navbar.classList.remove('scrolled');
    menu.classList.remove('scrolled');
  }
});


/*Login*/
function KTTK() {
  var name = document.getElementById("txtEmail").value;
  var pass = document.getElementById("txtPass").value;
  if (name.trim() === "" || pass.trim() === "") {
    event.preventDefault();
    window.alert("Xin hãy điền đầy đủ thông tin!");
  } else if (name === "Admin@gmail.com" && pass === "Admin@123") {
    event.preventDefault();
    window.alert("Bạn đã đăng nhập thành công!");
    window.location.href = "Home.html";
  } else {
    event.preventDefault();
    window.alert("Tài khoản hoặc mật khẩu của bạn đã sai. Xin mời nhập lại!");
  }
}



/*Register*/
function validateRegistrationForm() {
  const patternEmail = /^[a-zA-Z0-9._%+-]+@gmail\.com$/;
  const pattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$/;
  var name = document.getElementById("txtName").value;
  var email = document.getElementById("txtEmail").value;
  var pass1 = document.getElementById("txtPass1").value;
  var pass2 = document.getElementById("txtPass2").value;
  if (name.trim() === "" || email.trim() === "" || pass1.trim() === "" || pass2.trim() === "") {
    event.preventDefault();
    window.alert("Xin hãy điền đầy đủ thông tin!");
    return;
  }
  if (!patternEmail.test(email)) {
    window.alert("Địa chỉ email không hợp lệ!");
    return;
  }
  if (!pattern.test(pass1)) {
    window.alert("Mật khẩu không hợp lệ!");
    return;
  }
  if (pass1 !== pass2) {
    event.preventDefault();
    window.alert("Mật khẩu và mật khẩu nhập lại không khớp!");
    return;
  } else {
    window.alert("Tài khoản đã được đăng ký thành công, bạn có thể đăng nhập!");
    setTimeout(function () {
      window.location.href = "Login.html";
    }, 1000);
  }
}

//chay carousel(home)
document.addEventListener("DOMContentLoaded", function () {
  var carousel = document.querySelector("#carouselExample");
  var time = 4000;

  function autoSlide() {
    var next = carousel.querySelector(".carousel-item.active + .carousel-item") || carousel.querySelector(".carousel-item:first-child");
    carousel.querySelector(".carousel-item.active").classList.remove("active");
    next.classList.add("active");
  }

  setInterval(autoSlide, time);
});



var itemCount = 0; // Biến lưu trữ số lượng sản phẩm trong giỏ hàng
var totalAmount = 0; // Biến lưu trữ tổng số tiền

function addToCart(button) {
  var productContainer = button.closest('.product');
  var imgUrl = productContainer.querySelector('.product-img').style.backgroundImage;
  imgUrl = imgUrl.replace(/^url\(['"]?/, '').replace(/['"]?\)$/, ''); 
  var productName = productContainer.querySelector('.product-name').textContent;
  var productPrice = parseFloat(productContainer.querySelector('.price-new').textContent.replace(/\D/g, '')); // Lấy giá sản phẩm và chuyển đổi về kiểu số
  
  // Thêm các thông tin vào giỏ hàng
  var cartList = document.getElementById("cartList");
  var cartItem = document.createElement("li");
  cartItem.classList.add("cart-item");
  var countContainer = document.getElementById("countContainer");
  var cartItemHTML = `
    <div class="cart__item">
      <div class="img">
        <a href="#" class="cart-img">
          <img src="${imgUrl}">
        </a>
      </div>
      <div class="text">
        <div class="main-name">
          <a href="#">${productName}</a>
        </div>
        <div class="main-price">${productPrice.toLocaleString()}đ</div>
      </div>
      <div class="icon">
        <a href="#" class="order-delete">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash3-fill" viewBox="0 0 16 16">
            <path d="M11 1.5v1h3.5a.5.5 0 0 1 0 1h-.538l-.853 10.66A2 2 0 0 1 11.115 16h-6.23a2 2 0 0 1-1.994-1.84L2.038 3.5H1.5a.5.5 0 0 1 0-1H5v-1A1.5 1.5 0 0 1 6.5 0h3A1.5 1.5 0 0 1 11 1.5m-5 0v1h4v-1a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5M4.5 5.029l.5 8.5a.5.5 0 1 0 .998-.06l-.5-8.5a.5.5 0 1 0-.998.06Zm6.53-.528a.5.5 0 0 0-.528.47l-.5 8.5a.5.5 0 0 0 .998.058l.5-8.5a.5.5 0 0 0-.47-.528ZM8 4.5a.5.5 0 0 0-.5.5v8.5a.5.5 0 0 0 1 0V5a.5.5 0 0 0-.5-.5"/>
          </svg>
        </a>
      </div>
    </div>
  `;
  cartItem.innerHTML = cartItemHTML;
  cartList.appendChild(cartItem);
  
  // Tăng số lượng sản phẩm và cập nhật số hàng trong giỏ
  itemCount++;
  countContainer.innerText = "Số hàng trong giỏ: " + itemCount;

  // Tính tổng số tiền
  totalAmount += productPrice;
  var totalContainer = document.getElementById("countContainerr");
  totalContainer.innerText = "Tổng số tiền: " + totalAmount.toLocaleString() + "đ";

  // Bắt sự kiện xóa sản phẩm và giảm số hàng trong giỏ
  var deleteButton = cartItem.querySelector('.order-delete');
  deleteButton.addEventListener('click', function(event) {
    event.preventDefault(); 
    cartItem.remove();

    // Giảm số lượng sản phẩm và cập nhật số hàng trong giỏ
    itemCount--;
    countContainer.innerText = "Số hàng trong giỏ: " + itemCount;

    // Cập nhật tổng số tiền sau khi xóa sản phẩm
    totalAmount -= productPrice;
    totalContainer.innerText = "Tổng số tiền: " + totalAmount.toLocaleString() + "đ";
  });
}






//phong to anh
document.addEventListener("DOMContentLoaded", function () {
  const thumbnails = document.querySelectorAll(".image-thumbnail");
  thumbnails.forEach((thumbnail) => {
    thumbnail.addEventListener("mouseover", () => {
      const previewImage = document.querySelector(".image-preview img");
      const thumbnailImage = thumbnail.querySelector("img");
      previewImage.src = thumbnailImage.src;
      previewImage.alt = thumbnailImage.alt;
    });
  });
});





//KhuyenMai an vao phan tu tu cuon xuong dia chi
document.querySelectorAll('.scroll-link').forEach(link => {
  link.addEventListener('click', function (e) {
    e.preventDefault();

    const target = document.querySelector(this.getAttribute('href'));

    if (target) {
      target.scrollIntoView({ behavior: 'smooth' });
    }
  });
});     
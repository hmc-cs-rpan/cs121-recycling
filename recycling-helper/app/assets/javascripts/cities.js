
// When the user clicks on <li>, open the popup
function myFunction() {
    var popup = document.getElementById("logo");
    popup.classList.toggle("show");
}


function showImage() {
    var img = document.getElementById("logo");
    img.style.visibility = 'visible';
}

function setImageVisible(id, visible) {
    var img = document.getElementById(id);
    img.style.visibility = (visible ? 'visible' : 'hidden');
}


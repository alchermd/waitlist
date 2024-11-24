const form = document.getElementById("waitlist-form");

form.addEventListener("submit", function (e) {
  e.preventDefault();
  const email = document.getElementById("email").value;

  fetch(apiURL, {method: "POST", body: JSON.stringify({email})})
    .then(() => {
      alert("Thank you for signing up!");
      location.reload();
    })
    .catch(() => alert("Sorry, something went wrong."));
});

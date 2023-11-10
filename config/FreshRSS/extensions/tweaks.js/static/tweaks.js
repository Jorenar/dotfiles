const $ = document.querySelector.bind(document);

const params = new URLSearchParams(window.location.search);
if (!params.get("get")) {
  $("#nav_menu_read_all").remove();
  $("main#stream").style = "display: none";
  document.title = document.title.replace(/Main stream ./, "");
}

$(".prompt.alert.alert-warn > p > [href='./?c=subscription&a=add']")?.parentNode.parentNode.remove();

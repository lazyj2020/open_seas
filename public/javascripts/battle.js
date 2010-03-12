
function show_battle_mini(var1) {

var inventory=dhtmlwindow.open('battle', 'iframe', '/battles/show_battle/'+var1, 'Battle!', 'width=350px,height=250px,resize=1,scrolling=1,center=1', 'recal')
inventory.hide();

inventory.show()

inventory.onclose=function(){ //Run custom code when window is being closed (return false to cancel action):
inventory.hide();
return false;
}

}

// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.


// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});
var gamecenter = require('jp.coe.gamecenter');

obj = {
	callback:function (args) {
	  alert(JSON.stringify(args));
	}
}
gamecenter.authenticateLocalPlayer(obj);

var label = Ti.UI.createLabel();
label.addEventListener('click', function (args) {
	Ti.API.warn("click");
  gamecenter.showBoard();
});
win.add(label);
win.open();

// TODO: write your module tests here
Ti.API.info("module is => " + gamecenter);

label.text = gamecenter.example();

Ti.API.info("module exampleProp is => " + gamecenter.exampleProp);
gamecenter.exampleProp = "This is a test value";


if (Ti.Platform.name == "android") {
	var proxy = gamecenter.createExample({
		message: "Creating an example Proxy",
		backgroundColor: "red",
		width: 100,
		height: 100,
		top: 100,
		left: 150
	});

	proxy.printMessage("Hello world!");
	proxy.message = "Hi world!.  It's me again.";
	proxy.printMessage("Hello world!");
	win.add(proxy);
}


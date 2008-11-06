// Sammlung von Fixes. Methoden aus Prototype werden damit �berschrieben, wenn diese JS-Datei *nach* der prototype.js eingebunden wird:

Element.Methods.visible = function(element) {
    return ($(element).style.display != 'none') && (!$(element).hasClassName('hidden'));
};

Element.Methods.hide = function(element) {
//    $(element).style.display = 'none';
    $(element).oldDisplay = $(element).style.display;  // ggf. alten display-Value merken
    $(element).addClassName('hidden');
    return element;
};

Element.Methods.show = function(element) {
    var disp = (typeof($(element).oldDisplay)=='undefined' ? '' : $(element).oldDisplay);
    $(element).style.display = (disp=='none' ? '' : disp);  // alten display-Value wiederherstellen (z.B. display:inline;), sonst ''
    $(element).removeClassName('hidden');
    return element;
};

Ajax.Request.prototype.abort = function() {
  if(this.transport!=null){
  	if(this.transport.readyState<=1){
      // prevent and state change callbacks from being issued
      this.transport.onreadystatechange = Prototype.emptyFunction;
      // abort the XHR
      this.transport.abort();
      // update the request counter
      Ajax.activeRequestCount--;
      if(Ajax.activeRequestCount<0){
        Ajax.activeRequestCount=0;
      }
    }
    else{
      //alert("debug: readyState is >1, it's "+this.transport.readyState);
    }
  }
  else{
    //alert('debug: transport is null');
  }
};
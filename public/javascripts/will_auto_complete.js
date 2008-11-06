function will_auto_complete(search){
    url=search.getAttribute('url');
    if(typeof(url)=='undefined'){
        alert('Fehler: Der unobtrusive AutoCompleter benötigt das Attribut "url"!');
        return false;
    }

    var method = search.getAttribute('method') || 'post';
    var delay = search.getAttribute('delay') || 300;
    var update = search.getAttribute('update') || '';

    var val=strip(search.value);
    if(val==''){
      stop_ac_request();
      $(update).hide();
      search.last_ajax_search_words='';
      return false;
    }

    if((tokens=search.getAttribute('tokens'))!=null){
      for(var i=0;i<tokens.length;i++){
        val=val.split(tokens[i]).last();
      }
    }
    val=encodeURIComponent(val);
    ser=search.getAttribute('param_name')+"="+val;
    var parameters = "parameters:'"+ser+"',";
    if(typeof(search.last_ajax_search_words)=='undefined'){
      search.last_ajax_search_words='';
    }

    if(val!=search.last_ajax_search_words){  // nur erneut suchen, wenn sich der Suchbegriff geändert hat.
        if(typeof(ajaxACSearchTimer)!='undefined'){
          window.clearTimeout(ajaxACSearchTimer);
        }
        // Ggf. einen vorigen Request abbrechen:
        stop_ac_request();
        if(val!=search.last_ajax_search_words){
          cmd="ajaxACSearchRequest = new Ajax.Updater('"+update+"','"+url+"', {"+parameters+" asynchronous:true, evalScripts:true, method:'"+method+"', onComplete:function(transport){$('"+update+"').show();addAutoCompleteDivBehavior();}});$('"+search.id+"').last_ajax_search_words='"+val+"';";
          ajaxACSearchTimer = window.setTimeout(cmd,delay);
        }
    }
    return true;
}

// Stoppt einen ggf. laufenden zuvor abgeschickten Request
function stop_ac_request(){
  if(typeof(ajaxACSearchTimer)!='undefined'){
    window.clearTimeout(ajaxACSearchTimer);
  }
  if(typeof(ajaxACSearchRequest)!='undefined'){
    ajaxACSearchRequest.transport.abort();
  }
}

function ac_move_selection(s,direction){
//  alert('moving '+direction);
  var div=$(s.getAttribute('update'));
  if(div.select('li.selected').length>0){
    cur_sel=div.select('li.selected').first();
  }
  else{
    cur_sel=false;
  }
  div.select('li.selected').each(function(el){el.removeClassName('selected')});
  if(cur_sel && ((direction=='next' && (sib=cur_sel.nextSibling)!=null) || (direction=='previous' && (sib=cur_sel.previousSibling)!=null))){
//   if(cur_sel.nextSibling!=null){ alert(cur_sel.nextSibling.innerHTML); }else{alert('next is null');}
//   if(cur_sel.previousSibling!=null){ alert(cur_sel.previousSibling.innerHTML); }else{alert('previous is null');}
    sib.addClassName('selected');
  }
  else{
    if(div.select('li').length>0){ // vom letzten/ersten Element auf das erste/letzte springen (=> im Kreis laufen)
      if(direction=='previous'){
        div.select('li').last().addClassName('selected');
      }
      else{
        div.select('li').first().addClassName('selected');
      }
    }
  }
}


function fillAutoCompleteFields(edt,li,prefix){
  if(typeof(prefix)=='undefined'){prefix='';}
  if(vals=li.getAttribute('values')){
    params=$H(vals.parseQuery());
    hidden_fields_class=edt.id+'_hidden';
    $$('.'+hidden_fields_class).each(function(elm){elm.remove();})
    params.each(function(pair){
      field_name=prefix+'['+pair.key+']';
      field_id=prefix+'_'+pair.key;
      if(hdd=$(field_id)){
        hdd.value=pair.value;
      }
      else{
        hdd = new Element('input', {'class': hidden_fields_class, id: field_id, 'name': field_name, value: pair.value, type: 'hidden' } );
        Element.insert(edt, {after: hdd});  // Die Syntax ist etwas doof. Was hier passiert ist: das Elemend hdd wird nach dem Element edt eingefügt.
      }
    });
  }
  edt.value = li.getAttribute('val') || li.innerHTML;
}


function ac_go(s){
  stop_ac_request();
  var div=$($(s).getAttribute('update'));
  if(div.select('li.selected').length>0){
    li=div.select('li.selected').first();
    fillAutoCompleteFields(s,li);
  }
  doWhat=s.getAttribute('auto_submit');
  if(doWhat.toLowerCase()=='true'){
    if(s.form!=null){s.form.onsubmit ? s.form.onsubmit() : s.form.submit()};
  }
  else{
    if(doWhat!='' && doWhat.toLowerCase()!='false'){
      eval(doWhat);
    }
  }
  div.hide();
}

function addAutoCompleteBehavior(){
    Event.addBehavior({
      '.ujs_autocomplete:keyup' : function(e){  // keyup ist notwendig, weil bei keypress der getippte Buchstabe noch nicht im Textfeld steht!
         if(e.keyCode==Event.KEY_RETURN){
         }
         else{
           if(e.keyCode==Event.KEY_DOWN || e.keyCode==Event.KEY_UP){
             ac_move_selection(this,(e.keyCode==Event.KEY_DOWN ? 'next' : 'previous'));
             Event.stop(e);
           }
           else{
             will_auto_complete(this);
           }
         }
      },
      '.ujs_autocomplete:keypress' : function(e){
         if(e.keyCode==Event.KEY_RETURN){
           ac_go(this);
           Event.stop(e);
         }
         else{
           if(e.keyCode==Event.KEY_ESC){
             $(this.getAttribute('update')).hide();
           }
         }
      },
      '.ujs_autocomplete:keydown' : function(e) {
        if(e.keyCode==188){Event.stop(e); return false;} // kein Komma erlauben
          if(e.keyCode==Event.KEY_RETURN){
            ac_go(this);
            Event.stop(e);
          }
      },
      '.ujs_autocomplete:blur' : function(e) {
         if($(this.getAttribute('update')).select('li.selected').length==0){$(this.getAttribute('update')).hide();}
      }
    });
}
function addAutoCompleteDivBehavior(){
    Event.addBehavior({
      '.ac_results>ul>li:mouseover' : function(e){
        $(this).parentNode;
        elms=Element.select($(this).parentNode,'li.selected');
        elms.each(function(el){el.removeClassName('selected')});
        $(this).addClassName('selected');
      },
      '.ac_results>ul>li:click' : function(e){
        var field_id=Element.up(this,'div').getAttribute('input_field');
        ac_go($(field_id));
      }
    });
}

addAutoCompleteBehavior();
addAutoCompleteDivBehavior();
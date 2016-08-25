kibi query template
=====================


kibi_jdbc_jade_template
```
//- Jade generic table template example

- var display    = (config.open === true ? 'block' : 'none')
- var buttonText = (config.open === true ? '- ' : '+ ')


- var head = {vars:[]}; var keyid = "count";
- for (key in results[0]) { if (key == "date") {keyid="date";}; if (key != "@version" && key != "@timestamp" && key != "type" && key != "did" && key != "uid") {head.vars.push(key);}} 

- function keysrt1(b, a){return a["count"]-b["count"];}
- function keysrt2(b, a){aa=a["date"].split('-'); bb=b["date"].split('-'); if (aa[0] == bb[0]) {if (aa[1] == bb[1]) {return aa[2] - bb[2];} return aa[1] - bb[1];} return aa[0] - bb[0];}

- if (keyid=="date") {results.sort(keysrt2);}else{results.sort(keysrt1);}

style.
 thead.custome-header thead{color:#black;}

a(href="javascript:showHide('#{id}');", id="button-#{id}", class="snippetShowHideButton") #{buttonText} 
span= ' '
span(class="snippetLabel")= config.templateVars.label
span=  ' ('+results.length +') '
div(id="cont-#{id}", style={display: display})
  if results.length == 0
    div(class="table-vis-error") 
      h2
        i(class="fa fa-meh-o")
      h4 No results found
  else
    table(class='table table-condensed custome-header')
      thead
        tr
          each val in head.vars
            th= val
      tbody
        each binding in results
          tr
            each varName in head.vars
              if binding[varName]
                  td= binding[varName]
              else
                td
script(type='text/javascript').
  function showHide(id){
    var buttonEl = document.getElementById('button-' + id);
    var contEl = document.getElementById('cont-' + id);
    var style = window.getComputedStyle(contEl);
  
    if (style.display == 'none') {
      contEl.style.display = 'block';
      buttonEl.innerHTML = '- ';
    } else {
      buttonEl.innerHTML = '+ ';
      contEl.style.display = 'none';
    }
  }
  var x = !{JSON.stringify(results)};
```



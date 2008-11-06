function lstrip(s){
  return s.replace(/^\s*/,'');
}
function rstrip(s){
  return s.replace(/\s*$/,'');
}
function strip(s){
  return lstrip(rstrip(s));
}

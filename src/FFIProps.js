exports._unsafeGetProp = function(s, o) {
  return o[s];
};

exports._unsafeSetProp = function(s, v, o) {
  o[s] = v;
};

exports._unsafeModifyProp = function(s, f, o) {
  o[s] = f(o[s]);
};

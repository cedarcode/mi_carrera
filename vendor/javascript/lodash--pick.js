// lodash/pick@4.17.23 downloaded from https://ga.jspm.io/npm:lodash@4.17.23/pick.js

import{_ as r}from"./_/D1RyLe6k.js";import t from"./hasIn.js";import{_ as i}from"./_/DvSddA1E.js";import"./_/CMfEiC89.js";import"./_/C6UayejR.js";import"./isArray.js";import"./isSymbol.js";import"./_/BvE8bFHC.js";import"./_/Dn0SV0nH.js";import"./isObjectLike.js";import"./_stringToPath.js";import"./memoize.js";import"./_/zyyNK3QO.js";import"./_/slH5hUxU.js";import"./_/CX3pl0wT.js";import"./isFunction.js";import"./isObject.js";import"./eq.js";import"./_/LlMKPN53.js";import"./toString.js";import"./_/vyAkOenX.js";import"./_arrayMap.js";import"./_toKey.js";import"./_/xHPBtMAp.js";import"./_/a7LYJx9e.js";import"./_/BnLu2Ae7.js";import"./_/D284kTNg.js";import"./_isIndex.js";import"./_/DMIYD6lT.js";import"./isArguments.js";import"./isLength.js";import"./flatten.js";import"./_/BxuWyBWT.js";import"./_/CM6Cr2Fr.js";import"./_overRest.js";import"./_/BvalCKaw.js";import"./_/CnrLO_5Q.js";import"./constant.js";import"./identity.js";var s={};var o=r,m=t;
/**
 * The base implementation of `_.pick` without support for individual
 * property identifiers.
 *
 * @private
 * @param {Object} object The source object.
 * @param {string[]} paths The property paths to pick.
 * @returns {Object} Returns the new object.
 */function j(r,t){return o(r,t,(function(t,i){return m(r,i)}))}s=j;var p=s;var _={};var n=p,a=i;
/**
 * Creates an object composed of the picked `object` properties.
 *
 * @static
 * @since 0.1.0
 * @memberOf _
 * @category Object
 * @param {Object} object The source object.
 * @param {...(string|string[])} [paths] The property paths to pick.
 * @returns {Object} Returns the new object.
 * @example
 *
 * var object = { 'a': 1, 'b': '2', 'c': 3 };
 *
 * _.pick(object, ['a', 'c']);
 * // => { 'a': 1, 'c': 3 }
 */var e=a((function(r,t){return r==null?{}:n(r,t)}));_=e;var u=_;export{u as default};


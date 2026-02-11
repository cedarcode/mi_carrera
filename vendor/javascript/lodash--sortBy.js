// lodash/sortBy@4.17.23 downloaded from https://ga.jspm.io/npm:lodash@4.17.23/sortBy.js

import{_ as r}from"./_/BxuWyBWT.js";import{_ as t}from"./_/BoDEfFUC.js";import s from"./_baseRest.js";import{_ as i}from"./_/CDN6PQyr.js";import"./_/CM6Cr2Fr.js";import"./_/BvE8bFHC.js";import"./_/Dn0SV0nH.js";import"./isArguments.js";import"./isObjectLike.js";import"./isArray.js";import"./_arrayMap.js";import"./_/CMfEiC89.js";import"./_/C6UayejR.js";import"./isSymbol.js";import"./_stringToPath.js";import"./memoize.js";import"./_/zyyNK3QO.js";import"./_/slH5hUxU.js";import"./_/CX3pl0wT.js";import"./isFunction.js";import"./isObject.js";import"./eq.js";import"./_/LlMKPN53.js";import"./toString.js";import"./_/vyAkOenX.js";import"./_toKey.js";import"./_/B2UrIv26.js";import"./_/xo7OKOyA.js";import"./_/KcUd8WeJ.js";import"./_/C185uxAV.js";import"./_/DChXu6R8.js";import"./_/Ds9p3w0R.js";import"./_/BvL4QoUc.js";import"./_/CuYJwf9x.js";import"./_/DUb261R-.js";import"./_arrayFilter.js";import"./stubArray.js";import"./keys.js";import"./_/jOZaAajY.js";import"./_/VmqDG5Et.js";import"./isBuffer.js";import"./stubFalse.js";import"./_isIndex.js";import"./isTypedArray.js";import"./isLength.js";import"./_/CnuXciZb.js";import"./_/BBlDpEEY.js";import"./_/D4kZSuhp.js";import"./_/D13tfVQC.js";import"./_/Dh8BfxAr.js";import"./isArrayLike.js";import"./_getTag.js";import"./_/Cryr7UAc.js";import"./_/wnzyZZ7q.js";import"./_/DmtAut3B.js";import"./_/C39VktVg.js";import"./_/CXY7aZPI.js";import"./get.js";import"./hasIn.js";import"./_/DMIYD6lT.js";import"./identity.js";import"./property.js";import"./_baseProperty.js";import"./_/Z6UHdk_n.js";import"./_/DQZtRPbT.js";import"./_baseForOwn.js";import"./_/Ddyi9JOE.js";import"./_/CzhaiE9x.js";import"./_/CINdQ0h5.js";import"./_/BfwcFyl2.js";import"./_overRest.js";import"./_/BvalCKaw.js";import"./_/CnrLO_5Q.js";import"./constant.js";import"./_/D284kTNg.js";var o={};var m=r,p=t,j=s,_=i;
/**
 * Creates an array of elements, sorted in ascending order by the results of
 * running each element in a collection thru each iteratee. This method
 * performs a stable sort, that is, it preserves the original sort order of
 * equal elements. The iteratees are invoked with one argument: (value).
 *
 * @static
 * @memberOf _
 * @since 0.1.0
 * @category Collection
 * @param {Array|Object} collection The collection to iterate over.
 * @param {...(Function|Function[])} [iteratees=[_.identity]]
 *  The iteratees to sort by.
 * @returns {Array} Returns the new sorted array.
 * @example
 *
 * var users = [
 *   { 'user': 'fred',   'age': 48 },
 *   { 'user': 'barney', 'age': 36 },
 *   { 'user': 'fred',   'age': 30 },
 *   { 'user': 'barney', 'age': 34 }
 * ];
 *
 * _.sortBy(users, [function(o) { return o.user; }]);
 * // => objects for [['barney', 36], ['barney', 34], ['fred', 48], ['fred', 30]]
 *
 * _.sortBy(users, ['user', 'age']);
 * // => objects for [['barney', 34], ['barney', 36], ['fred', 30], ['fred', 48]]
 */var e=j((function(r,t){if(r==null)return[];var s=t.length;s>1&&_(r,t[0],t[1])?t=[]:s>2&&_(t[0],t[1],t[2])&&(t=[t[0]]);return p(r,m(t,1),[])}));o=e;var a=o;export{a as default};


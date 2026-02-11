// lodash/mapValues@4.17.23 downloaded from https://ga.jspm.io/npm:lodash@4.17.23/mapValues.js

import{_ as r}from"./_/BnLu2Ae7.js";import t from"./_baseForOwn.js";import{_ as s}from"./_/B2UrIv26.js";import"./_/D284kTNg.js";import"./_/slH5hUxU.js";import"./_/CX3pl0wT.js";import"./isFunction.js";import"./_/BvE8bFHC.js";import"./_/Dn0SV0nH.js";import"./isObject.js";import"./_/Ddyi9JOE.js";import"./_/CzhaiE9x.js";import"./keys.js";import"./_/jOZaAajY.js";import"./_/VmqDG5Et.js";import"./isArguments.js";import"./isObjectLike.js";import"./isArray.js";import"./isBuffer.js";import"./stubFalse.js";import"./_isIndex.js";import"./isTypedArray.js";import"./isLength.js";import"./_/CnuXciZb.js";import"./_/BBlDpEEY.js";import"./_/D4kZSuhp.js";import"./_/D13tfVQC.js";import"./_/Dh8BfxAr.js";import"./isArrayLike.js";import"./_/xo7OKOyA.js";import"./_/KcUd8WeJ.js";import"./_/C185uxAV.js";import"./_/zyyNK3QO.js";import"./eq.js";import"./_/LlMKPN53.js";import"./_/DChXu6R8.js";import"./_/Ds9p3w0R.js";import"./_/BvL4QoUc.js";import"./_/CuYJwf9x.js";import"./_/DUb261R-.js";import"./_/CM6Cr2Fr.js";import"./_arrayFilter.js";import"./stubArray.js";import"./_getTag.js";import"./_/Cryr7UAc.js";import"./_/wnzyZZ7q.js";import"./_/DmtAut3B.js";import"./_/C39VktVg.js";import"./_/CXY7aZPI.js";import"./get.js";import"./_/CMfEiC89.js";import"./_/C6UayejR.js";import"./isSymbol.js";import"./_stringToPath.js";import"./memoize.js";import"./toString.js";import"./_/vyAkOenX.js";import"./_arrayMap.js";import"./_toKey.js";import"./hasIn.js";import"./_/DMIYD6lT.js";import"./identity.js";import"./property.js";import"./_baseProperty.js";var i={};var o=r,m=t,p=s;
/**
 * Creates an object with the same keys as `object` and values generated
 * by running each own enumerable string keyed property of `object` thru
 * `iteratee`. The iteratee is invoked with three arguments:
 * (value, key, object).
 *
 * @static
 * @memberOf _
 * @since 2.4.0
 * @category Object
 * @param {Object} object The object to iterate over.
 * @param {Function} [iteratee=_.identity] The function invoked per iteration.
 * @returns {Object} Returns the new mapped object.
 * @see _.mapKeys
 * @example
 *
 * var users = {
 *   'fred':    { 'user': 'fred',    'age': 40 },
 *   'pebbles': { 'user': 'pebbles', 'age': 1 }
 * };
 *
 * _.mapValues(users, function(o) { return o.age; });
 * // => { 'fred': 40, 'pebbles': 1 } (iteration order is not guaranteed)
 *
 * // The `_.property` iteratee shorthand.
 * _.mapValues(users, 'age');
 * // => { 'fred': 40, 'pebbles': 1 } (iteration order is not guaranteed)
 */function j(r,t){var s={};t=p(t,3);m(r,(function(r,i,m){o(s,i,t(r,i,m))}));return s}i=j;var _=i;export{_ as default};


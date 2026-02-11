// lodash/find@4.17.23 downloaded from https://ga.jspm.io/npm:lodash@4.17.23/find.js

import{_ as r}from"./_/BfZdcU_o.js";import t from"./findIndex.js";import"./_/B2UrIv26.js";import"./_/xo7OKOyA.js";import"./_/KcUd8WeJ.js";import"./_/C185uxAV.js";import"./_/zyyNK3QO.js";import"./_/slH5hUxU.js";import"./_/CX3pl0wT.js";import"./isFunction.js";import"./_/BvE8bFHC.js";import"./_/Dn0SV0nH.js";import"./isObject.js";import"./eq.js";import"./_/LlMKPN53.js";import"./_/DChXu6R8.js";import"./_/Ds9p3w0R.js";import"./_/BvL4QoUc.js";import"./_/CuYJwf9x.js";import"./_/DUb261R-.js";import"./_/CM6Cr2Fr.js";import"./isArray.js";import"./_arrayFilter.js";import"./stubArray.js";import"./keys.js";import"./_/jOZaAajY.js";import"./_/VmqDG5Et.js";import"./isArguments.js";import"./isObjectLike.js";import"./isBuffer.js";import"./stubFalse.js";import"./_isIndex.js";import"./isTypedArray.js";import"./isLength.js";import"./_/CnuXciZb.js";import"./_/BBlDpEEY.js";import"./_/D4kZSuhp.js";import"./_/D13tfVQC.js";import"./_/Dh8BfxAr.js";import"./isArrayLike.js";import"./_getTag.js";import"./_/Cryr7UAc.js";import"./_/wnzyZZ7q.js";import"./_/DmtAut3B.js";import"./_/C39VktVg.js";import"./_/CXY7aZPI.js";import"./get.js";import"./_/CMfEiC89.js";import"./_/C6UayejR.js";import"./isSymbol.js";import"./_stringToPath.js";import"./memoize.js";import"./toString.js";import"./_/vyAkOenX.js";import"./_arrayMap.js";import"./_toKey.js";import"./hasIn.js";import"./_/DMIYD6lT.js";import"./identity.js";import"./property.js";import"./_baseProperty.js";import"./_/CMAxJ1vP.js";import"./toInteger.js";import"./toFinite.js";import"./toNumber.js";import"./_/6zVdtdXu.js";import"./_/D4PH4Nkb.js";var i={};var s=r,o=t;
/**
 * Iterates over elements of `collection`, returning the first element
 * `predicate` returns truthy for. The predicate is invoked with three
 * arguments: (value, index|key, collection).
 *
 * @static
 * @memberOf _
 * @since 0.1.0
 * @category Collection
 * @param {Array|Object} collection The collection to inspect.
 * @param {Function} [predicate=_.identity] The function invoked per iteration.
 * @param {number} [fromIndex=0] The index to search from.
 * @returns {*} Returns the matched element, else `undefined`.
 * @example
 *
 * var users = [
 *   { 'user': 'barney',  'age': 36, 'active': true },
 *   { 'user': 'fred',    'age': 40, 'active': false },
 *   { 'user': 'pebbles', 'age': 1,  'active': true }
 * ];
 *
 * _.find(users, function(o) { return o.age < 40; });
 * // => object for 'barney'
 *
 * // The `_.matches` iteratee shorthand.
 * _.find(users, { 'age': 1, 'active': true });
 * // => object for 'pebbles'
 *
 * // The `_.matchesProperty` iteratee shorthand.
 * _.find(users, ['active', false]);
 * // => object for 'fred'
 *
 * // The `_.property` iteratee shorthand.
 * _.find(users, 'active');
 * // => object for 'barney'
 */var m=s(o);i=m;var p=i;export{p as default};


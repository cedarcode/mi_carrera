// lodash/filter@4.17.23 downloaded from https://ga.jspm.io/npm:lodash@4.17.23/filter.js

import r from"./_arrayFilter.js";import{_ as t}from"./_/QK3VZgNf.js";import{_ as s}from"./_/B2UrIv26.js";import i from"./isArray.js";import"./_/DQZtRPbT.js";import"./_baseForOwn.js";import"./_/Ddyi9JOE.js";import"./_/CzhaiE9x.js";import"./keys.js";import"./_/jOZaAajY.js";import"./_/VmqDG5Et.js";import"./isArguments.js";import"./_/BvE8bFHC.js";import"./_/Dn0SV0nH.js";import"./isObjectLike.js";import"./isBuffer.js";import"./stubFalse.js";import"./_isIndex.js";import"./isTypedArray.js";import"./isLength.js";import"./_/CnuXciZb.js";import"./_/BBlDpEEY.js";import"./_/D4kZSuhp.js";import"./_/D13tfVQC.js";import"./_/Dh8BfxAr.js";import"./isArrayLike.js";import"./isFunction.js";import"./isObject.js";import"./_/CINdQ0h5.js";import"./_/xo7OKOyA.js";import"./_/KcUd8WeJ.js";import"./_/C185uxAV.js";import"./_/zyyNK3QO.js";import"./_/slH5hUxU.js";import"./_/CX3pl0wT.js";import"./eq.js";import"./_/LlMKPN53.js";import"./_/DChXu6R8.js";import"./_/Ds9p3w0R.js";import"./_/BvL4QoUc.js";import"./_/CuYJwf9x.js";import"./_/DUb261R-.js";import"./_/CM6Cr2Fr.js";import"./stubArray.js";import"./_getTag.js";import"./_/Cryr7UAc.js";import"./_/wnzyZZ7q.js";import"./_/DmtAut3B.js";import"./_/C39VktVg.js";import"./_/CXY7aZPI.js";import"./get.js";import"./_/CMfEiC89.js";import"./_/C6UayejR.js";import"./isSymbol.js";import"./_stringToPath.js";import"./memoize.js";import"./toString.js";import"./_/vyAkOenX.js";import"./_arrayMap.js";import"./_toKey.js";import"./hasIn.js";import"./_/DMIYD6lT.js";import"./identity.js";import"./property.js";import"./_baseProperty.js";var o={};var m=r,p=t,j=s,_=i;
/**
 * Iterates over elements of `collection`, returning an array of all elements
 * `predicate` returns truthy for. The predicate is invoked with three
 * arguments: (value, index|key, collection).
 *
 * **Note:** Unlike `_.remove`, this method returns a new array.
 *
 * @static
 * @memberOf _
 * @since 0.1.0
 * @category Collection
 * @param {Array|Object} collection The collection to iterate over.
 * @param {Function} [predicate=_.identity] The function invoked per iteration.
 * @returns {Array} Returns the new filtered array.
 * @see _.reject
 * @example
 *
 * var users = [
 *   { 'user': 'barney', 'age': 36, 'active': true },
 *   { 'user': 'fred',   'age': 40, 'active': false }
 * ];
 *
 * _.filter(users, function(o) { return !o.active; });
 * // => objects for ['fred']
 *
 * // The `_.matches` iteratee shorthand.
 * _.filter(users, { 'age': 36, 'active': true });
 * // => objects for ['barney']
 *
 * // The `_.matchesProperty` iteratee shorthand.
 * _.filter(users, ['active', false]);
 * // => objects for ['fred']
 *
 * // The `_.property` iteratee shorthand.
 * _.filter(users, 'active');
 * // => objects for ['barney']
 *
 * // Combining several predicates using `_.overEvery` or `_.overSome`.
 * _.filter(users, _.overSome([{ 'age': 36 }, ['age', 40]]));
 * // => objects for ['fred', 'barney']
 */function e(r,t){var s=_(r)?m:p;return s(r,j(t,3))}o=e;var a=o;export{a as default};


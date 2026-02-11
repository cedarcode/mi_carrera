// lodash/transform@4.17.23 downloaded from https://ga.jspm.io/npm:lodash@4.17.23/transform.js

import r from"./_arrayEach.js";import{_ as t}from"./_/C6Qn17De.js";import s from"./_baseForOwn.js";import{_ as o}from"./_/B2UrIv26.js";import{_ as i}from"./_/D_LYu-lG.js";import m from"./isArray.js";import p from"./isBuffer.js";import j from"./isFunction.js";import _ from"./isObject.js";import a from"./isTypedArray.js";import"./_/Ddyi9JOE.js";import"./_/CzhaiE9x.js";import"./keys.js";import"./_/jOZaAajY.js";import"./_/VmqDG5Et.js";import"./isArguments.js";import"./_/BvE8bFHC.js";import"./_/Dn0SV0nH.js";import"./isObjectLike.js";import"./_isIndex.js";import"./_/D4kZSuhp.js";import"./_/D13tfVQC.js";import"./_/Dh8BfxAr.js";import"./isArrayLike.js";import"./isLength.js";import"./stubFalse.js";import"./_/CnuXciZb.js";import"./_/BBlDpEEY.js";import"./_/xo7OKOyA.js";import"./_/KcUd8WeJ.js";import"./_/C185uxAV.js";import"./_/zyyNK3QO.js";import"./_/slH5hUxU.js";import"./_/CX3pl0wT.js";import"./eq.js";import"./_/LlMKPN53.js";import"./_/DChXu6R8.js";import"./_/Ds9p3w0R.js";import"./_/BvL4QoUc.js";import"./_/CuYJwf9x.js";import"./_/DUb261R-.js";import"./_/CM6Cr2Fr.js";import"./_arrayFilter.js";import"./stubArray.js";import"./_getTag.js";import"./_/Cryr7UAc.js";import"./_/wnzyZZ7q.js";import"./_/DmtAut3B.js";import"./_/C39VktVg.js";import"./_/CXY7aZPI.js";import"./get.js";import"./_/CMfEiC89.js";import"./_/C6UayejR.js";import"./isSymbol.js";import"./_stringToPath.js";import"./memoize.js";import"./toString.js";import"./_/vyAkOenX.js";import"./_arrayMap.js";import"./_toKey.js";import"./hasIn.js";import"./_/DMIYD6lT.js";import"./identity.js";import"./property.js";import"./_baseProperty.js";var e={};var n=r,f=t,y=s,u=o,c=i,b=m,g=p,l=j,A=_,d=a;
/**
 * An alternative to `_.reduce`; this method transforms `object` to a new
 * `accumulator` object which is the result of running each of its own
 * enumerable string keyed properties thru `iteratee`, with each invocation
 * potentially mutating the `accumulator` object. If `accumulator` is not
 * provided, a new object with the same `[[Prototype]]` will be used. The
 * iteratee is invoked with four arguments: (accumulator, value, key, object).
 * Iteratee functions may exit iteration early by explicitly returning `false`.
 *
 * @static
 * @memberOf _
 * @since 1.3.0
 * @category Object
 * @param {Object} object The object to iterate over.
 * @param {Function} [iteratee=_.identity] The function invoked per iteration.
 * @param {*} [accumulator] The custom accumulator value.
 * @returns {*} Returns the accumulated value.
 * @example
 *
 * _.transform([2, 3, 4], function(result, n) {
 *   result.push(n *= n);
 *   return n % 2 == 0;
 * }, []);
 * // => [4, 9]
 *
 * _.transform({ 'a': 1, 'b': 2, 'c': 1 }, function(result, value, key) {
 *   (result[value] || (result[value] = [])).push(key);
 * }, {});
 * // => { '1': ['a', 'c'], '2': ['b'] }
 */function v(r,t,s){var o=b(r),i=o||g(r)||d(r);t=u(t,4);if(s==null){var m=r&&r.constructor;s=i?o?new m:[]:A(r)&&l(m)?f(c(r)):{}}(i?n:y)(r,(function(r,o,i){return t(s,r,o,i)}));return s}e=v;var F=e;export{F as default};


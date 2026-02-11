// lodash/size@4.17.23 downloaded from https://ga.jspm.io/npm:lodash@4.17.23/size.js

import{_ as r}from"./_/D4kZSuhp.js";import t from"./_getTag.js";import i from"./isArrayLike.js";import o from"./isString.js";import{_ as s}from"./_/Cb8Jbk3n.js";import"./_/D13tfVQC.js";import"./_/Dh8BfxAr.js";import"./_/slH5hUxU.js";import"./_/CX3pl0wT.js";import"./isFunction.js";import"./_/BvE8bFHC.js";import"./_/Dn0SV0nH.js";import"./isObject.js";import"./_/LlMKPN53.js";import"./_/Cryr7UAc.js";import"./_/wnzyZZ7q.js";import"./isLength.js";import"./isArray.js";import"./isObjectLike.js";import"./_baseProperty.js";import"./_/DXmvs_Vb.js";var m={};var j=r,p=t,e=i,_=o,a=s;var n="[object Map]",f="[object Set]";
/**
 * Gets the size of `collection` by returning its length for array-like
 * values or the number of own enumerable string keyed properties for objects.
 *
 * @static
 * @memberOf _
 * @since 0.1.0
 * @category Collection
 * @param {Array|Object|string} collection The collection to inspect.
 * @returns {number} Returns the collection size.
 * @example
 *
 * _.size([1, 2, 3]);
 * // => 3
 *
 * _.size({ 'a': 1, 'b': 2 });
 * // => 2
 *
 * _.size('pebbles');
 * // => 7
 */function u(r){if(r==null)return 0;if(e(r))return _(r)?a(r):r.length;var t=p(r);return t==n||t==f?r.size:j(r).length}m=u;var b=m;export{b as default};


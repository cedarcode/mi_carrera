// lodash/merge@4.17.23 downloaded from https://ga.jspm.io/npm:lodash@4.17.23/merge.js

import{_ as s}from"./_/DEpj5VFB.js";import{_ as i}from"./_/Dx9n6dRR.js";import"./_/C185uxAV.js";import"./_/zyyNK3QO.js";import"./_/slH5hUxU.js";import"./_/CX3pl0wT.js";import"./isFunction.js";import"./_/BvE8bFHC.js";import"./_/Dn0SV0nH.js";import"./isObject.js";import"./eq.js";import"./_/LlMKPN53.js";import"./_/BnLu2Ae7.js";import"./_/D284kTNg.js";import"./_/Ddyi9JOE.js";import"./_/CzhaiE9x.js";import"./_/DrU3MxU8.js";import"./_/C6Qn17De.js";import"./_/D_LYu-lG.js";import"./_/Dh8BfxAr.js";import"./_/D13tfVQC.js";import"./_copyArray.js";import"./isArguments.js";import"./isObjectLike.js";import"./isArray.js";import"./isArrayLikeObject.js";import"./isArrayLike.js";import"./isLength.js";import"./isBuffer.js";import"./stubFalse.js";import"./isPlainObject.js";import"./isTypedArray.js";import"./_/CnuXciZb.js";import"./_/BBlDpEEY.js";import"./toPlainObject.js";import"./_/DTnwRaJo.js";import"./_/a7LYJx9e.js";import"./keysIn.js";import"./_/jOZaAajY.js";import"./_/VmqDG5Et.js";import"./_isIndex.js";import"./_baseRest.js";import"./identity.js";import"./_overRest.js";import"./_/BvalCKaw.js";import"./_/CnrLO_5Q.js";import"./constant.js";import"./_/CDN6PQyr.js";var r={};var t=s,o=i;
/**
 * This method is like `_.assign` except that it recursively merges own and
 * inherited enumerable string keyed properties of source objects into the
 * destination object. Source properties that resolve to `undefined` are
 * skipped if a destination value exists. Array and plain object properties
 * are merged recursively. Other objects and value types are overridden by
 * assignment. Source objects are applied from left to right. Subsequent
 * sources overwrite property assignments of previous sources.
 *
 * **Note:** This method mutates `object`.
 *
 * @static
 * @memberOf _
 * @since 0.5.0
 * @category Object
 * @param {Object} object The destination object.
 * @param {...Object} [sources] The source objects.
 * @returns {Object} Returns `object`.
 * @example
 *
 * var object = {
 *   'a': [{ 'b': 2 }, { 'd': 4 }]
 * };
 *
 * var other = {
 *   'a': [{ 'c': 3 }, { 'e': 5 }]
 * };
 *
 * _.merge(object, other);
 * // => { 'a': [{ 'b': 2, 'c': 3 }, { 'd': 4, 'e': 5 }] }
 */var j=o((function(s,i,r){t(s,i,r)}));r=j;var m=r;export{m as default};


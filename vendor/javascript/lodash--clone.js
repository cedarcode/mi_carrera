// lodash/clone@4.17.23 downloaded from https://ga.jspm.io/npm:lodash@4.17.23/clone.js

import r from"./_baseClone.js";import"./_/C185uxAV.js";import"./_/zyyNK3QO.js";import"./_/slH5hUxU.js";import"./_/CX3pl0wT.js";import"./isFunction.js";import"./_/BvE8bFHC.js";import"./_/Dn0SV0nH.js";import"./isObject.js";import"./eq.js";import"./_/LlMKPN53.js";import"./_arrayEach.js";import"./_/a7LYJx9e.js";import"./_/BnLu2Ae7.js";import"./_/D284kTNg.js";import"./_/DMlDzvUV.js";import"./_/DTnwRaJo.js";import"./keys.js";import"./_/jOZaAajY.js";import"./_/VmqDG5Et.js";import"./isArguments.js";import"./isObjectLike.js";import"./isArray.js";import"./isBuffer.js";import"./stubFalse.js";import"./_isIndex.js";import"./isTypedArray.js";import"./isLength.js";import"./_/CnuXciZb.js";import"./_/BBlDpEEY.js";import"./_/D4kZSuhp.js";import"./_/D13tfVQC.js";import"./_/Dh8BfxAr.js";import"./isArrayLike.js";import"./keysIn.js";import"./_/DrU3MxU8.js";import"./_/C6Qn17De.js";import"./_/D_LYu-lG.js";import"./_copyArray.js";import"./_/DUb261R-.js";import"./_/CM6Cr2Fr.js";import"./_arrayFilter.js";import"./stubArray.js";import"./_/BfWXp5W5.js";import"./_getTag.js";import"./_/Cryr7UAc.js";import"./_/wnzyZZ7q.js";import"./isMap.js";import"./isSet.js";var s={};var i=r;var t=4;
/**
 * Creates a shallow clone of `value`.
 *
 * **Note:** This method is loosely based on the
 * [structured clone algorithm](https://mdn.io/Structured_clone_algorithm)
 * and supports cloning arrays, array buffers, booleans, date objects, maps,
 * numbers, `Object` objects, regexes, sets, strings, symbols, and typed
 * arrays. The own enumerable properties of `arguments` objects are cloned
 * as plain objects. An empty object is returned for uncloneable values such
 * as error objects, functions, DOM nodes, and WeakMaps.
 *
 * @static
 * @memberOf _
 * @since 0.1.0
 * @category Lang
 * @param {*} value The value to clone.
 * @returns {*} Returns the cloned value.
 * @see _.cloneDeep
 * @example
 *
 * var objects = [{ 'a': 1 }, { 'b': 2 }];
 *
 * var shallow = _.clone(objects);
 * console.log(shallow[0] === objects[0]);
 * // => true
 */function o(r){return i(r,t)}s=o;var p=s;export{p as default};


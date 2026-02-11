// lodash/isFunction@4.17.23 downloaded from https://ga.jspm.io/npm:lodash@4.17.23/isFunction.js

import{_ as r}from"./_/BvE8bFHC.js";import t from"./isObject.js";import"./_/Dn0SV0nH.js";var o={};var e=r,n=t;var a="[object AsyncFunction]",c="[object Function]",i="[object GeneratorFunction]",j="[object Proxy]";
/**
 * Checks if `value` is classified as a `Function` object.
 *
 * @static
 * @memberOf _
 * @since 0.1.0
 * @category Lang
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is a function, else `false`.
 * @example
 *
 * _.isFunction(_);
 * // => true
 *
 * _.isFunction(/abc/);
 * // => false
 */function s(r){if(!n(r))return false;var t=e(r);return t==c||t==i||t==a||t==j}o=s;var u=o;export{u as default};


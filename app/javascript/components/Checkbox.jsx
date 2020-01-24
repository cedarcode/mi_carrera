import React from "react";

export default function Checkbox(props) {
  return(
    <div className="mdc-checkbox">
      <input type="checkbox" defaultChecked={props.checked} disabled={props.disabled} className="mdc-checkbox__native-control" />

      <div className="mdc-checkbox__background">
        <svg className="mdc-checkbox__checkmark" viewBox="0 0 24 24">
          <path className="mdc-checkbox__checkmark-path" fill="none" d="M1.73,12.91 8.1,19.28 22.79,4.59"/>
        </svg>

        <div className="mdc-checkbox__mixedmark"></div>
      </div>
    </div>
  );
}

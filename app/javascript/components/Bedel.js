import React from "react";
import Subject from './Subject';

export default function Bedel(props) {
  return <div className="mdc-list">
    {
      props.subjects.map((subject, index) => (
        <Subject key={index} subject={subject} />
      ))
    }
  </div>;
}

import React from "react";
import SubjectRow from './SubjectRow';

export default function Bedel(props) {
  return <div className="mdc-list">
    {
      props.subjects.map((subject, index) => (
        <SubjectRow key={index} subject={subject} />
      ))
    }
  </div>;
}

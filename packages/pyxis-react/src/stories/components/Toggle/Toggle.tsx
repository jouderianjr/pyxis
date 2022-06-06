import {FC} from "react";
import classNames from "classnames";

// TODO: remove this implementation when Toggle will be implemented in pyxis-react
// Non-exhaustive implementation, made for testing purposes only.

const getClasses = (disabled:boolean) => classNames(
  'toggle',
  {
    'toggle--disabled': disabled
  });

const Toggle:FC<ToggleProps> = ({disabled = false, checked = false, label=false, id}) => (
  <div className={getClasses(disabled)}>
    {label && <label className="form-label" htmlFor={id}>Label</label>}
    <input
      aria-label={label ? undefined : "description"}
      aria-checked={checked}
      id={id}
      type="checkbox"
      role="switch"
      className="toggle__input"
      disabled={disabled}
      defaultChecked={checked} />
  </div>
);

interface ToggleProps {
  disabled?:boolean;
  id:string;
  checked?:boolean;
  label?:boolean;
}

export default Toggle;

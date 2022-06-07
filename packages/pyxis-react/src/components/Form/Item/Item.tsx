import React, { cloneElement, FC, ReactElement } from 'react';
import Label, { LabelProps } from 'components/Form/Label';
import Input, { InputProps } from 'components/Form/Input';

const mapChildren = (children: ReactElement<LabelProps | FormFieldProps | ReactElement>[]) => children.map(
  (child) => {
    switch (child.type) {
      case Label:
        return ['label', child];
      case Input:
        return ['field', child];
      default:
        return ['additionalContent', child];
    }
  },
);

const getIds = (id:string) => ({
  labelId: `${id}-label`,
  fieldId: `${id}-field`,
  errorId: `${id}-error`,
  hintId: `${id}-hint`,
});

const Item: FC<ItemProps> = ({
  children,
  className,
  errorMessage,
  hint,
  id,
}) => {
  const { label, field, additionalContent } = Object.fromEntries(mapChildren(
    Array.isArray(children) ? children : [children],
  ));

  const {
    labelId, fieldId, errorId, hintId,
  } = getIds(id);

  return (
    <div
      className={`form-item ${className || ''}`}
      data-testid={id}
      id={id}
    >
      {label && cloneElement(label, {
        htmlFor: fieldId,
        id: labelId,
      })}

      <div className="form-item__wrapper">
        {field && cloneElement(field, {
          id: fieldId,
          hasError: !!errorMessage,
          errorId: !!errorMessage && errorId,
          hintId,
        })}

        {hint && !errorMessage && (
          <div className="form-item__hint" id={hintId}>
            {hint}
          </div>
        )}

        {errorMessage && (
          <div className="form-item__error-message" id={errorId}>
            {errorMessage}
          </div>
        )}
      </div>

      {additionalContent}

    </div>
  );
};

export default Item;

type FormFieldProps = InputProps;

export interface ItemProps {
  children:
    | ReactElement<FormFieldProps>
    | ReactElement<LabelProps | FormFieldProps | ReactElement>[];
  className?: string;
  errorMessage?: string;
  hint?: string;
  id: string;
}

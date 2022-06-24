import React, { FC, ReactElement, ReactNode } from 'react';
import Label, { LabelProps } from './Label';
import Item, { ItemProps } from './Item';
import Input, { InputProps } from './Input';

const Form: FC<FormProps> & FormChildren = ({ className, children }) => (
  <form className={className}>
    {children}
  </form>
);

Form.AdditionalContent = React.Fragment;
Form.Input = Input;
Form.Item = Item;
Form.Label = Label;

export default Form;

interface FormProps {
  children: ReactElement<FormChildren> | ReactElement<FormChildren>[];
  className?: string;
}

interface FormChildren {
  AdditionalContent: FC<AdditionalContentProps>;
  Input: FC<Omit<InputProps, 'id'>>;
  Item: FC<ItemProps>;
  Label: FC<Omit<LabelProps, 'id' | 'htmlFor'>>;
}

interface AdditionalContentProps {
  children: ReactNode;
}

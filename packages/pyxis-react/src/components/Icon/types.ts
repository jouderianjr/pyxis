import { ReactElement } from 'react';

type Size = 's' | 'm' | 'l';
type BoxedVariant = 'neutral' | 'brand' | 'success' | 'alert' | 'error';

export interface IconProps {
  alt?: boolean;
  boxedVariant?: BoxedVariant;
  children?: ReactElement;
  className?: string;
  description?: string;
  id?: string;
  size?: Size;
}

export default {};

export type { Size };

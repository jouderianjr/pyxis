type Size = 's' | 'm' | 'l';
type BoxedVariant = 'neutral' | 'brand' | 'success' | 'alert' | 'error';

export interface IconProps {
  alt?: boolean;
  boxedVariant?: BoxedVariant;
  className?: string;
  description?: string;
  id?: string;
  size?: Size;
}

export default {};

export type { Size };

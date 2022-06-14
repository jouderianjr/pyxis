type IconSize = 's' | 'm' | 'l';
type IconBoxedVariant = 'neutral' | 'brand' | 'success' | 'alert' | 'error';

export interface IconProps {
  alt?: boolean;
  boxedVariant?: IconBoxedVariant;
  className?: string;
  description?: string;
  id?: string;
  size?: IconSize;
}

export default {};

export type { IconSize };

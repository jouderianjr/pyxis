import { render, screen } from '@testing-library/react';
import { pascalToKebab } from 'commons/utils/string';
import Badge, { Variant } from './Badge';

const variants: Variant[] = ['brand', 'action', 'error', 'success', 'alert', 'neutralGradient', 'brandGradient', 'ghost'];

describe('Badge component', () => {
  test('it should mount', () => {
    render(<Badge id="badge-id">Badge</Badge>);
    const badge = screen.getByTestId('badge-id');
    expect(badge).toBeInTheDocument();
    expect(badge).toHaveClass('badge');
  });

  describe('with variants', () => {
    variants.forEach(
      (variant) => test(`Variant ${variant} should have the proper class`, () => {
        render(<Badge id="badge-id" variant={variant}>Badge</Badge>);
        const badge = screen.getByTestId('badge-id');
        expect(badge).toHaveClass(`badge--${pascalToKebab(variant)}`);
      }),
    );
  });

  test('it should have proper classes if alt', () => {
    render(<Badge alt id="badge-id">Badge</Badge>);
    const badge = screen.getByTestId('badge-id');
    expect(badge).toHaveClass('badge--alt');
  });

  test('should have the proper custom classes if passed', () => {
    render(<Badge alt className="my-custom-class" id="badge-id">Badge</Badge>);
    const badge = screen.getByTestId('badge-id');
    expect(badge).toHaveClass('my-custom-class');
  });

  test('should have id if passed', () => {
    render(<Badge alt id="badge-id">Badge</Badge>);
    const badge = screen.getByTestId('badge-id');
    expect(badge).toHaveProperty('id', 'badge-id');
  });
});

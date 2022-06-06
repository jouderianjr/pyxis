import { render, screen } from '@testing-library/react';
import { IconPen } from 'components/Icon/Icons';
import Button from './Button';

describe('Button component', () => {
  describe('with default options', () => {
    test('should render a primary variant with type submit and textual content', () => {
      render(<Button id="child-test" variant="primary">Primary</Button>);
      const button = screen.getByTestId('child-test');
      expect(button).toBeInTheDocument();
      expect(button).toHaveTextContent('Primary');
      expect(button).toHaveClass('button button--medium');
      expect(button).toHaveAttribute('type', 'button');
    });
  });

  describe('has a variant option', () => {
    test('should be primary', () => {
      render(<Button id="variant-primary" variant="primary">Button</Button>);
      expect(screen.getByTestId('variant-primary')).toHaveClass('button--primary');
    });

    test('should be secondary', () => {
      render(<Button id="variant-secondary" variant="secondary">Button</Button>);
      expect(screen.getByTestId('variant-secondary')).toHaveClass('button--secondary');
    });

    test('should be tertiary', () => {
      render(<Button id="variant-tertiary" variant="tertiary">Button</Button>);
      expect(screen.getByTestId('variant-tertiary')).toHaveClass('button--tertiary');
    });

    test('should be brand', () => {
      render(<Button id="variant-brand" variant="brand">Button</Button>);
      expect(screen.getByTestId('variant-brand')).toHaveClass('button--brand');
    });

    test('should be ghost', () => {
      render(<Button id="variant-ghost" variant="ghost">Button</Button>);
      expect(screen.getByTestId('variant-ghost')).toHaveClass('button--ghost');
    });
  });

  describe('has a size option', () => {
    test('should be huge', () => {
      render(<Button id="size-huge" size="huge" variant="primary">Button</Button>);
      expect(screen.getByTestId('size-huge')).toHaveClass('button--huge');
    });

    test('should be large', () => {
      render(<Button id="size-large" size="large" variant="primary">Button</Button>);
      expect(screen.getByTestId('size-large')).toHaveClass('button--large');
    });

    test('should be medium', () => {
      render(<Button id="size-medium" size="medium" variant="primary">Button</Button>);
      expect(screen.getByTestId('size-medium')).toHaveClass('button--medium');
    });

    test('should be small', () => {
      render(<Button id="size-small" size="small" variant="primary">Button</Button>);
      expect(screen.getByTestId('size-small')).toHaveClass('button--small');
    });
  });

  describe('icon options', () => {
    test('should render the icon', () => {
      render(<Button icon={IconPen} id="icon-button" variant="primary">Button</Button>);
      const button = screen.getByTestId('icon-button');
      const icon = button.querySelector('svg');
      expect(button).toHaveClass('button--prepend-icon');
      expect(icon).toBeInTheDocument();
    });

    test('should be a prepend icon', () => {
      render(
        <Button icon={IconPen} iconPlacement="prepend" id="icon-prepend-button" variant="primary">Button</Button>,
      );
      const prepend = screen.getByTestId('icon-prepend-button');
      const prependIcon = prepend.querySelector('svg');
      expect(prepend).toHaveClass('button--prepend-icon');
      expect(prependIcon).toBeInTheDocument();
    });

    test('should be a append icon', () => {
      render(
        <Button icon={IconPen} iconPlacement="append" id="icon-append-button" variant="primary">Button</Button>,
      );
      const append = screen.getByTestId('icon-append-button');
      const appendIcon = append.querySelector('svg');
      expect(append).toHaveClass('button--append-icon');
      expect(appendIcon).toBeInTheDocument();
    });

    test('should be only icon', () => {
      render(
        <Button icon={IconPen} iconPlacement="only" id="icon-only-button" variant="primary">Button</Button>,
      );
      const only = screen.getByTestId('icon-only-button');
      const onlyIcon = only.querySelector('svg');
      expect(only).toHaveClass('button--icon-only');
      expect(onlyIcon).toBeInTheDocument();
    });
  });

  describe('generic options', () => {
    test('should have an alternative color', () => {
      render(<Button alt id="alt-button" variant="primary">Button</Button>);
      expect(screen.getByTestId('alt-button')).toHaveClass('button--alt');
    });

    test('should have a shadow', () => {
      render(<Button id="shadow-button" shadow variant="primary">Button</Button>);
      expect(screen.getByTestId('shadow-button')).toHaveClass('button--shadow');
    });

    test('should be loading', () => {
      render(<Button id="loading-button" loading variant="primary">Button</Button>);
      expect(screen.getByTestId('loading-button')).toHaveClass('button--loading');
      expect(screen.getByTestId('loading-button')).toHaveAttribute('tabIndex', '-1');
    });

    test('should be content-width', () => {
      render(<Button contentWidth id="content-width-button" variant="primary">Button</Button>);
      expect(screen.getByTestId('content-width-button')).toHaveClass('button--content-width');
    });

    test('should have tabIndex', () => {
      render(<Button id="tab-index-button" tabIndex={-1} variant="primary">Button</Button>);
      expect(screen.getByTestId('tab-index-button')).toHaveAttribute('tabIndex', '-1');
    });
  });
});

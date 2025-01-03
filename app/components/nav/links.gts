import type { TOC } from '@ember/component/template-only';
import NavSubLink from 'jikan-da/components/nav/sub-link';

interface Signature {
  Args: {
    burgerMenu: boolean;
  };
  Blocks: {};
  Element: HTMLElement;
}
const NavLinks: TOC<Signature> = <template>
  <ul class="menu" ...attributes>
    <li>
      <a href="/">Home</a>
    </li>
    <li>
      <a href="/time-tracking">Time Tracking</a>
    </li>
    <li>
      <a href="/charge-codes">Charge Codes</a>
    </li>
    <li>
      <NavSubLink @burgerMenu={{@burgerMenu}} />
    </li>
  </ul>
</template>;

export default NavLinks;

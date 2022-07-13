export interface CardItem {
  /**
   * @since 1.0.0
   */
  itemId: string;

  /**
   * @since 1.0.0
   */
  price: number;

  /**
   * @since 1.0.0
   */
  quantity: number;
}

export interface CardItems {
  items: CardItem[];
}

export interface Purchase extends CardItems {
  /**
   * @since 1.0.0
   */
  orderId: string;
}

export interface CustomEvent {
  /**
   * The eventName
   *
   * @since 1.0.0
   */
  name: string;

  /**
   * The event attributes
   *
   * @since 1.0.0
   */
  attributes?: {[key: string]: string};
}

/**
 * Based on `searchTerm`
 */
interface RecommendedProductSearchLogic {
  /**
   * @since 1.0.0
   */
  type: 'search';

  /**
   * @since 1.0.0
   */
  value: string;
}

/**
 * Based on `cartItems`
 */
interface RecommendedProductCartLogic {
  /**
   * @since 1.0.0
   */
  type: 'cart';

  /**
   * @since 1.0.0
   */
  value: CardItem[];
}

/**
 * Based on `itemViewId`
 */
interface RecommendedProductRelatedLogic {
  /**
   * @since 1.0.0
   */
  type: 'related';

  /**
   * @since 1.0.0
   */
  value: string;
}

/**
 * Based on `categoryPath`
 */
interface RecommendedProductCategoryLogic {
  /**
   * @since 1.0.0
   */
  type: 'category';

  /**
   * @since 1.0.0
   */
  value: string;
}

/**
 * Based on `itemViewId`
 */
interface RecommendedProductAlsoBoughtLogic {
  /**
   * @since 1.0.0
   */
  type: 'also_bought';

  /**
   * @since 1.0.0
   */
  value: string;
}

/**
 * Based on `categoryPath`
 */
interface RecommendedProductPopularLogic {
  /**
   * @since 1.0.0
   */
  type: 'popular';

  /**
   * @since 1.0.0
   */
  value: string;
}

/**
 * Based on based on current browsing and activity
 *
 * Optionally based on the variants
 */
interface RecommendedProductPersonalLogic {
  /**
   * @since 1.0.0
   */
  type: 'personal';

  /**
   * @since 1.0.0
   */
  value?: string[];
}

/**
 * Based on most recent browsing behaviour
 *
 * Optionally based on the variants
 */
interface RecommendedProductHomeLogic {
  /**
   * @since 1.0.0
   */
  type: 'home';

  /**
   * @since 1.0.0
   */
  value?: string[];
}

export type RecommendedProductLogic =
  | RecommendedProductSearchLogic
  | RecommendedProductCartLogic
  | RecommendedProductRelatedLogic
  | RecommendedProductCategoryLogic
  | RecommendedProductAlsoBoughtLogic
  | RecommendedProductPopularLogic
  | RecommendedProductPersonalLogic
  | RecommendedProductHomeLogic;

type RecommendedProductFilterType = 'include' | 'exclude';
type RecommendedProductValueFilterComparatorType = 'isValue' | 'hasValue';

interface RecommendedProductValueFilter {
  /**
   * @since 1.0.0
   */
  filterType: RecommendedProductFilterType;

  /**
   * `isValue`: checking if the `field` is matching the `value`,
   *
   * `hasValue`: One of the `field` values is equal to `expectation value` (applicable only to fields containing multiple values)
   *
   * @since 1.0.0
   */
  comparatorType: RecommendedProductValueFilterComparatorType;

  /**
   * @since 1.0.0
   */
  field: string;

  /**
   * @since 1.0.0
   */
  value: string;
}

type RecommendedProductArrayFilterComparatorType = 'inValues' | 'overlapsValues';

interface RecommendedProductArrayFilter {
  /**
   * @since 1.0.0
   */
  filterType: RecommendedProductFilterType;

  /**
   * `inValues`: any of the `values` has a match with the `field`,
   *
   * `overlapsValues`: One or more of the `field` values are found in `expectation values` (applicable only to fields containing multiple values)
   *
   * @since 1.0.0
   */
  comparatorType: RecommendedProductArrayFilterComparatorType;

  /**
   * @since 1.0.0
   */
  field: string;

  /**
   * @since 1.0.0
   */
  value: string[];
}

export type RecommendedProductFilter = RecommendedProductValueFilter | RecommendedProductArrayFilter;

export interface RecommendedProductOptions {
  /**
   * The logic that should be used.
   *
   * @since 1.0.0
   */
  logic: RecommendedProductLogic;

  /**
   * You can filter product recommendations with the SDK. There are two types of filters: `Exclude` or `Include`. In every case there are four types of comparators you can use to compare your chosen field to the `value`.
   *
   * This is an optional parameter.
   *
   * @since 1.0.0
   */
  filter?: RecommendedProductFilter[];

  /**
   * You can limit the number of recommended products received by defining a `limit`.
   *
   * @default 5
   *
   * @since 1.0.0
   */
  limit?: number;

  /**
   * You can personalize the recommendation further by setting the `availabilityZones` parameter of the recommendation, to only recommend the locally available products. This is an optional parameter.
   *
   * @since 1.0.0
   */
  availabilityZone?: string;
}

export interface Product {
  /**
   * @since 1.0.0
   */
  productId: string;

  /**
   * @since 1.0.0
   */
  title: string;

  /**
   * @since 1.0.0
   */
  linkUrl: string;

  /**
   * @since 1.0.0
   */
  customFields: {[key: string]: any};

  /**
   * @since 1.0.0
   */
  feature: string;

  /**
   * @since 1.0.0
   */
  cohort: string;

  /**
   * @since 1.0.0
   */
  imageUrl?: string;

  /**
   * @since 1.0.0
   */
  zoomImageUrl?: string;

  /**
   * @since 1.0.0
   */
  categoryPath?: string;

  /**
   * @since 1.0.0
   */
  available?: number;

  /**
   * @since 1.0.0
   */
  productDescription?: string;

  /**
   * @since 1.0.0
   */
  price?: number;

  /**
   * @since 1.0.0
   */
  msrp?: number;

  /**
   * @since 1.0.0
   */
  album?: string;

  /**
   * @since 1.0.0
   */
  actor?: string;

  /**
   * @since 1.0.0
   */
  artist?: string;

  /**
   * @since 1.0.0
   */
  author?: string;

  /**
   * @since 1.0.0
   */
  brand?: string;

  /**
   * @since 1.0.0
   */
  year?: number;
}

export interface RecommendedProducts {
  /**
   * @since 1.0.0
   */
  products: Product[];
}

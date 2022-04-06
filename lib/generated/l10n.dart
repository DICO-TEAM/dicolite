// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Add pool`
  String get addPool {
    return Intl.message(
      'Add pool',
      name: 'addPool',
      desc: '',
      args: [],
    );
  }

  /// `Start in`
  String get startIn {
    return Intl.message(
      'Start in',
      name: 'startIn',
      desc: '',
      args: [],
    );
  }

  /// `The pools only shows the pools whose start time is less than 1 day`
  String get poolShowTimeTips {
    return Intl.message(
      'The pools only shows the pools whose start time is less than 1 day',
      name: 'poolShowTimeTips',
      desc: '',
      args: [],
    );
  }

  /// `Tip: The reward token added to the pool will not be returned`
  String get addPoolTips {
    return Intl.message(
      'Tip: The reward token added to the pool will not be returned',
      name: 'addPoolTips',
      desc: '',
      args: [],
    );
  }

  /// `Reward amount`
  String get rewardAmount {
    return Intl.message(
      'Reward amount',
      name: 'rewardAmount',
      desc: '',
      args: [],
    );
  }

  /// `Reward currency id`
  String get rewardCurrencyId {
    return Intl.message(
      'Reward currency id',
      name: 'rewardCurrencyId',
      desc: '',
      args: [],
    );
  }

  /// `Stake currency id`
  String get stakeCurrencyId {
    return Intl.message(
      'Stake currency id',
      name: 'stakeCurrencyId',
      desc: '',
      args: [],
    );
  }

  /// `ROI Calculator`
  String get ROICalculator {
    return Intl.message(
      'ROI Calculator',
      name: 'ROICalculator',
      desc: '',
      args: [],
    );
  }

  /// `Profit`
  String get profit {
    return Intl.message(
      'Profit',
      name: 'profit',
      desc: '',
      args: [],
    );
  }

  /// `Staked for`
  String get stakedFor {
    return Intl.message(
      'Staked for',
      name: 'stakedFor',
      desc: '',
      args: [],
    );
  }

  /// `Burn`
  String get burn {
    return Intl.message(
      'Burn',
      name: 'burn',
      desc: '',
      args: [],
    );
  }

  /// `Burning NFT will increase your mint quota, burning it?`
  String get burnNftTip {
    return Intl.message(
      'Burning NFT will increase your mint quota, burning it?',
      name: 'burnNftTip',
      desc: '',
      args: [],
    );
  }

  /// `Not enough quota, cannot mint!`
  String get noQuota {
    return Intl.message(
      'Not enough quota, cannot mint!',
      name: 'noQuota',
      desc: '',
      args: [],
    );
  }

  /// `Not enough NFT, cannot mint!`
  String get noNFT {
    return Intl.message(
      'Not enough NFT, cannot mint!',
      name: 'noNFT',
      desc: '',
      args: [],
    );
  }

  /// `Seller`
  String get seller {
    return Intl.message(
      'Seller',
      name: 'seller',
      desc: '',
      args: [],
    );
  }

  /// `Owner`
  String get owner {
    return Intl.message(
      'Owner',
      name: 'owner',
      desc: '',
      args: [],
    );
  }

  /// `Newest`
  String get newest {
    return Intl.message(
      'Newest',
      name: 'newest',
      desc: '',
      args: [],
    );
  }

  /// `Ascend`
  String get ascend {
    return Intl.message(
      'Ascend',
      name: 'ascend',
      desc: '',
      args: [],
    );
  }

  /// `Descend`
  String get descend {
    return Intl.message(
      'Descend',
      name: 'descend',
      desc: '',
      args: [],
    );
  }

  /// `Avatar`
  String get avatar {
    return Intl.message(
      'Avatar',
      name: 'avatar',
      desc: '',
      args: [],
    );
  }

  /// `As avatar`
  String get asAvatar {
    return Intl.message(
      'As avatar',
      name: 'asAvatar',
      desc: '',
      args: [],
    );
  }

  /// `Remove avatar`
  String get removeAvatar {
    return Intl.message(
      'Remove avatar',
      name: 'removeAvatar',
      desc: '',
      args: [],
    );
  }

  /// `Set as avatar`
  String get setAsAvatar {
    return Intl.message(
      'Set as avatar',
      name: 'setAsAvatar',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message(
      'Select',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `Sell`
  String get sell {
    return Intl.message(
      'Sell',
      name: 'sell',
      desc: '',
      args: [],
    );
  }

  /// `Cancel sale`
  String get cancelSale {
    return Intl.message(
      'Cancel sale',
      name: 'cancelSale',
      desc: '',
      args: [],
    );
  }

  /// `Sale`
  String get sale {
    return Intl.message(
      'Sale',
      name: 'sale',
      desc: '',
      args: [],
    );
  }

  /// `Buy`
  String get buy {
    return Intl.message(
      'Buy',
      name: 'buy',
      desc: '',
      args: [],
    );
  }

  /// `Condition (USD)`
  String get condition {
    return Intl.message(
      'Condition (USD)',
      name: 'condition',
      desc: '',
      args: [],
    );
  }

  /// `Total remaining value of my ICO`
  String get totalRemainValueOfMyIco {
    return Intl.message(
      'Total remaining value of my ICO',
      name: 'totalRemainValueOfMyIco',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `ON SALE`
  String get on_sale {
    return Intl.message(
      'ON SALE',
      name: 'on_sale',
      desc: '',
      args: [],
    );
  }

  /// `My NFT`
  String get my_nft {
    return Intl.message(
      'My NFT',
      name: 'my_nft',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to claim the tokens unlocked in vesting?`
  String get vestingClaim {
    return Intl.message(
      'Are you sure to claim the tokens unlocked in vesting?',
      name: 'vestingClaim',
      desc: '',
      args: [],
    );
  }

  /// `Claim`
  String get claim {
    return Intl.message(
      'Claim',
      name: 'claim',
      desc: '',
      args: [],
    );
  }

  /// `Mint NFT`
  String get mint_nft {
    return Intl.message(
      'Mint NFT',
      name: 'mint_nft',
      desc: '',
      args: [],
    );
  }

  /// `Initial price discovery`
  String get lbpDesc {
    return Intl.message(
      'Initial price discovery',
      name: 'lbpDesc',
      desc: '',
      args: [],
    );
  }

  /// `Investors decide how to allocate the raised funds and retain the right to trace the remaining investment funds`
  String get daoDesc {
    return Intl.message(
      'Investors decide how to allocate the raised funds and retain the right to trace the remaining investment funds',
      name: 'daoDesc',
      desc: '',
      args: [],
    );
  }

  /// `Time left`
  String get timeLeft {
    return Intl.message(
      'Time left',
      name: 'timeLeft',
      desc: '',
      args: [],
    );
  }

  /// `Price Changes`
  String get priceChanges {
    return Intl.message(
      'Price Changes',
      name: 'priceChanges',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `LBP exchange`
  String get lbpExchange {
    return Intl.message(
      'LBP exchange',
      name: 'lbpExchange',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for the council to add fundraising assets`
  String get waitingForAddFundraisingAssets {
    return Intl.message(
      'Waiting for the council to add fundraising assets',
      name: 'waitingForAddFundraisingAssets',
      desc: '',
      args: [],
    );
  }

  /// `Cannot use fundraising assets`
  String get cannotUseFundraisingAssets {
    return Intl.message(
      'Cannot use fundraising assets',
      name: 'cannotUseFundraisingAssets',
      desc: '',
      args: [],
    );
  }

  /// `weights`
  String get weights {
    return Intl.message(
      'weights',
      name: 'weights',
      desc: '',
      args: [],
    );
  }

  /// `Now`
  String get now {
    return Intl.message(
      'Now',
      name: 'now',
      desc: '',
      args: [],
    );
  }

  /// `Initial`
  String get initial {
    return Intl.message(
      'Initial',
      name: 'initial',
      desc: '',
      args: [],
    );
  }

  /// `days later`
  String get daysLater {
    return Intl.message(
      'days later',
      name: 'daysLater',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get duration {
    return Intl.message(
      'Duration',
      name: 'duration',
      desc: '',
      args: [],
    );
  }

  /// `Create LBP`
  String get createLbp {
    return Intl.message(
      'Create LBP',
      name: 'createLbp',
      desc: '',
      args: [],
    );
  }

  /// `AFS currency id`
  String get afsAssetId {
    return Intl.message(
      'AFS currency id',
      name: 'afsAssetId',
      desc: '',
      args: [],
    );
  }

  /// `AFS asset`
  String get afsAsset {
    return Intl.message(
      'AFS asset',
      name: 'afsAsset',
      desc: '',
      args: [],
    );
  }

  /// `Fundraising asset`
  String get fundraisingAsset {
    return Intl.message(
      'Fundraising asset',
      name: 'fundraisingAsset',
      desc: '',
      args: [],
    );
  }

  /// `AFS amount`
  String get afsBalance {
    return Intl.message(
      'AFS amount',
      name: 'afsBalance',
      desc: '',
      args: [],
    );
  }

  /// `Fundraising amount`
  String get fundraisingBalance {
    return Intl.message(
      'Fundraising amount',
      name: 'fundraisingBalance',
      desc: '',
      args: [],
    );
  }

  /// `AFS start weights`
  String get afsStartWeight {
    return Intl.message(
      'AFS start weights',
      name: 'afsStartWeight',
      desc: '',
      args: [],
    );
  }

  /// `AFS end weights`
  String get afsEndWeight {
    return Intl.message(
      'AFS end weights',
      name: 'afsEndWeight',
      desc: '',
      args: [],
    );
  }

  /// `Fundraising start weights`
  String get fundraisingStartWeight {
    return Intl.message(
      'Fundraising start weights',
      name: 'fundraisingStartWeight',
      desc: '',
      args: [],
    );
  }

  /// `Fundraising end weights`
  String get fundraisingEndWeight {
    return Intl.message(
      'Fundraising end weights',
      name: 'fundraisingEndWeight',
      desc: '',
      args: [],
    );
  }

  /// `Start time`
  String get startTime {
    return Intl.message(
      'Start time',
      name: 'startTime',
      desc: '',
      args: [],
    );
  }

  /// `End time`
  String get endTime {
    return Intl.message(
      'End time',
      name: 'endTime',
      desc: '',
      args: [],
    );
  }

  /// `Times of weights changes`
  String get steps {
    return Intl.message(
      'Times of weights changes',
      name: 'steps',
      desc: '',
      args: [],
    );
  }

  /// `Please add tokens or LP token`
  String get stakeLPTip {
    return Intl.message(
      'Please add tokens or LP token',
      name: 'stakeLPTip',
      desc: '',
      args: [],
    );
  }

  /// `Block height`
  String get blockHeight {
    return Intl.message(
      'Block height',
      name: 'blockHeight',
      desc: '',
      args: [],
    );
  }

  /// `Harvest`
  String get harvest {
    return Intl.message(
      'Harvest',
      name: 'harvest',
      desc: '',
      args: [],
    );
  }

  /// `Multiplier`
  String get multiplier {
    return Intl.message(
      'Multiplier',
      name: 'multiplier',
      desc: '',
      args: [],
    );
  }

  /// `For example, if a 1x farm received 1 DICO per block, a 40x farm would receive 40 DICO per block.`
  String get multiplierTip {
    return Intl.message(
      'For example, if a 1x farm received 1 DICO per block, a 40x farm would receive 40 DICO per block.',
      name: 'multiplierTip',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw`
  String get withdraw {
    return Intl.message(
      'Withdraw',
      name: 'withdraw',
      desc: '',
      args: [],
    );
  }

  /// `Earn`
  String get earn {
    return Intl.message(
      'Earn',
      name: 'earn',
      desc: '',
      args: [],
    );
  }

  /// `Earned`
  String get earned {
    return Intl.message(
      'Earned',
      name: 'earned',
      desc: '',
      args: [],
    );
  }

  /// `APR`
  String get APR {
    return Intl.message(
      'APR',
      name: 'APR',
      desc: '',
      args: [],
    );
  }

  /// `Staked`
  String get stakedOnly {
    return Intl.message(
      'Staked',
      name: 'stakedOnly',
      desc: '',
      args: [],
    );
  }

  /// `Live`
  String get live {
    return Intl.message(
      'Live',
      name: 'live',
      desc: '',
      args: [],
    );
  }

  /// `Stake tokens or LP tokens to earn.`
  String get farmSubtitle {
    return Intl.message(
      'Stake tokens or LP tokens to earn.',
      name: 'farmSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `ME`
  String get me {
    return Intl.message(
      'ME',
      name: 'me',
      desc: '',
      args: [],
    );
  }

  /// `Prices and pool share`
  String get pricesAndPoolShare {
    return Intl.message(
      'Prices and pool share',
      name: 'pricesAndPoolShare',
      desc: '',
      args: [],
    );
  }

  /// `Per`
  String get per {
    return Intl.message(
      'Per',
      name: 'per',
      desc: '',
      args: [],
    );
  }

  /// `When you add liquidity, you will receive pool tokens representing your position. These tokens automatically earn fees proportional to your share of the pool, and can be redeemed at any time.`
  String get addLiquidityTip {
    return Intl.message(
      'When you add liquidity, you will receive pool tokens representing your position. These tokens automatically earn fees proportional to your share of the pool, and can be redeemed at any time.',
      name: 'addLiquidityTip',
      desc: '',
      args: [],
    );
  }

  /// `Share of rate`
  String get shareOfRate {
    return Intl.message(
      'Share of rate',
      name: 'shareOfRate',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Supply`
  String get supply {
    return Intl.message(
      'Supply',
      name: 'supply',
      desc: '',
      args: [],
    );
  }

  /// `Route`
  String get route {
    return Intl.message(
      'Route',
      name: 'route',
      desc: '',
      args: [],
    );
  }

  /// `Search token symbol or ID`
  String get searchTip {
    return Intl.message(
      'Search token symbol or ID',
      name: 'searchTip',
      desc: '',
      args: [],
    );
  }

  /// `No liquidity`
  String get noLiquidity {
    return Intl.message(
      'No liquidity',
      name: 'noLiquidity',
      desc: '',
      args: [],
    );
  }

  /// `Insufficient liquidity`
  String get insufficientLiquidity {
    return Intl.message(
      'Insufficient liquidity',
      name: 'insufficientLiquidity',
      desc: '',
      args: [],
    );
  }

  /// `Price impact`
  String get priceImpact {
    return Intl.message(
      'Price impact',
      name: 'priceImpact',
      desc: '',
      args: [],
    );
  }

  /// `Min received`
  String get minReceived {
    return Intl.message(
      'Min received',
      name: 'minReceived',
      desc: '',
      args: [],
    );
  }

  /// `Max sent`
  String get maxSent {
    return Intl.message(
      'Max sent',
      name: 'maxSent',
      desc: '',
      args: [],
    );
  }

  /// `Price updated`
  String get priceUpdated {
    return Intl.message(
      'Price updated',
      name: 'priceUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Confirm exchange`
  String get confirmExchange {
    return Intl.message(
      'Confirm exchange',
      name: 'confirmExchange',
      desc: '',
      args: [],
    );
  }

  /// `Slippage`
  String get slippage {
    return Intl.message(
      'Slippage',
      name: 'slippage',
      desc: '',
      args: [],
    );
  }

  /// `(estimated)`
  String get estimated {
    return Intl.message(
      '(estimated)',
      name: 'estimated',
      desc: '',
      args: [],
    );
  }

  /// `Transaction settings`
  String get transactionSettings {
    return Intl.message(
      'Transaction settings',
      name: 'transactionSettings',
      desc: '',
      args: [],
    );
  }

  /// `Max`
  String get max {
    return Intl.message(
      'Max',
      name: 'max',
      desc: '',
      args: [],
    );
  }

  /// `Min`
  String get min {
    return Intl.message(
      'Min',
      name: 'min',
      desc: '',
      args: [],
    );
  }

  /// `Set price range`
  String get setPriceRange {
    return Intl.message(
      'Set price range',
      name: 'setPriceRange',
      desc: '',
      args: [],
    );
  }

  /// `Fee tier`
  String get feeTier {
    return Intl.message(
      'Fee tier',
      name: 'feeTier',
      desc: '',
      args: [],
    );
  }

  /// `Deposit amounts`
  String get depositAmounts {
    return Intl.message(
      'Deposit amounts',
      name: 'depositAmounts',
      desc: '',
      args: [],
    );
  }

  /// `Invalid pair`
  String get invalidPair {
    return Intl.message(
      'Invalid pair',
      name: 'invalidPair',
      desc: '',
      args: [],
    );
  }

  /// `Select token`
  String get selectToken {
    return Intl.message(
      'Select token',
      name: 'selectToken',
      desc: '',
      args: [],
    );
  }

  /// `Select pair`
  String get selectPair {
    return Intl.message(
      'Select pair',
      name: 'selectPair',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Your total pool tokens`
  String get yourTotalPoolTokens {
    return Intl.message(
      'Your total pool tokens',
      name: 'yourTotalPoolTokens',
      desc: '',
      args: [],
    );
  }

  /// `Remove liquidity`
  String get removeLiquidity {
    return Intl.message(
      'Remove liquidity',
      name: 'removeLiquidity',
      desc: '',
      args: [],
    );
  }

  /// `Add liquidity`
  String get addLiquidity {
    return Intl.message(
      'Add liquidity',
      name: 'addLiquidity',
      desc: '',
      args: [],
    );
  }

  /// `Liquidity`
  String get liquidity {
    return Intl.message(
      'Liquidity',
      name: 'liquidity',
      desc: '',
      args: [],
    );
  }

  /// `Pool`
  String get pool {
    return Intl.message(
      'Pool',
      name: 'pool',
      desc: '',
      args: [],
    );
  }

  /// `Pools`
  String get pools {
    return Intl.message(
      'Pools',
      name: 'pools',
      desc: '',
      args: [],
    );
  }

  /// `Farms`
  String get farms {
    return Intl.message(
      'Farms',
      name: 'farms',
      desc: '',
      args: [],
    );
  }

  /// `Farm`
  String get farm {
    return Intl.message(
      'Farm',
      name: 'farm',
      desc: '',
      args: [],
    );
  }

  /// `Exchanged`
  String get exchanged {
    return Intl.message(
      'Exchanged',
      name: 'exchanged',
      desc: '',
      args: [],
    );
  }

  /// `Exchange`
  String get exchange {
    return Intl.message(
      'Exchange',
      name: 'exchange',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to exchange? price impact is`
  String get priceImpactTips {
    return Intl.message(
      'Are you sure to exchange? price impact is',
      name: 'priceImpactTips',
      desc: '',
      args: [],
    );
  }

  /// `Swap`
  String get swap {
    return Intl.message(
      'Swap',
      name: 'swap',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for the project party to apply for the release of funds`
  String get waitApplicationRelease {
    return Intl.message(
      'Waiting for the project party to apply for the release of funds',
      name: 'waitApplicationRelease',
      desc: '',
      args: [],
    );
  }

  /// `Please in English`
  String get pleaseInEnglish {
    return Intl.message(
      'Please in English',
      name: 'pleaseInEnglish',
      desc: '',
      args: [],
    );
  }

  /// `Not support svg`
  String get notSupportSVG {
    return Intl.message(
      'Not support svg',
      name: 'notSupportSVG',
      desc: '',
      args: [],
    );
  }

  /// `Terminated`
  String get terminated {
    return Intl.message(
      'Terminated',
      name: 'terminated',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Release`
  String get release {
    return Intl.message(
      'Release',
      name: 'release',
      desc: '',
      args: [],
    );
  }

  /// `Reward`
  String get reward {
    return Intl.message(
      'Reward',
      name: 'reward',
      desc: '',
      args: [],
    );
  }

  /// `Get reward`
  String get getReward {
    return Intl.message(
      'Get reward',
      name: 'getReward',
      desc: '',
      args: [],
    );
  }

  /// `Unreleased`
  String get unReleased {
    return Intl.message(
      'Unreleased',
      name: 'unReleased',
      desc: '',
      args: [],
    );
  }

  /// `Releasable`
  String get releasable {
    return Intl.message(
      'Releasable',
      name: 'releasable',
      desc: '',
      args: [],
    );
  }

  /// `Unlockable`
  String get unlockable {
    return Intl.message(
      'Unlockable',
      name: 'unlockable',
      desc: '',
      args: [],
    );
  }

  /// `Unlock`
  String get unlock {
    return Intl.message(
      'Unlock',
      name: 'unlock',
      desc: '',
      args: [],
    );
  }

  /// `Locks`
  String get locks {
    return Intl.message(
      'Locks',
      name: 'locks',
      desc: '',
      args: [],
    );
  }

  /// `Proposal type`
  String get proposalType {
    return Intl.message(
      'Proposal type',
      name: 'proposalType',
      desc: '',
      args: [],
    );
  }

  /// `Release progress`
  String get releaseProgress {
    return Intl.message(
      'Release progress',
      name: 'releaseProgress',
      desc: '',
      args: [],
    );
  }

  /// `Request release`
  String get requestRelease {
    return Intl.message(
      'Request release',
      name: 'requestRelease',
      desc: '',
      args: [],
    );
  }

  /// `Cancel request release`
  String get cancelRequestRelease {
    return Intl.message(
      'Cancel request release',
      name: 'cancelRequestRelease',
      desc: '',
      args: [],
    );
  }

  /// `My record`
  String get myRecord {
    return Intl.message(
      'My record',
      name: 'myRecord',
      desc: '',
      args: [],
    );
  }

  /// `Total value`
  String get totalValue {
    return Intl.message(
      'Total value',
      name: 'totalValue',
      desc: '',
      args: [],
    );
  }

  /// `Application`
  String get application {
    return Intl.message(
      'Application',
      name: 'application',
      desc: '',
      args: [],
    );
  }

  /// `Stop project`
  String get stopProject {
    return Intl.message(
      'Stop project',
      name: 'stopProject',
      desc: '',
      args: [],
    );
  }

  /// `Create motion`
  String get createMotion {
    return Intl.message(
      'Create motion',
      name: 'createMotion',
      desc: '',
      args: [],
    );
  }

  /// `Stop project motion`
  String get stopProjectMotion {
    return Intl.message(
      'Stop project motion',
      name: 'stopProjectMotion',
      desc: '',
      args: [],
    );
  }

  /// `Coming`
  String get coming {
    return Intl.message(
      'Coming',
      name: 'coming',
      desc: '',
      args: [],
    );
  }

  /// `Ongoing`
  String get ongoing {
    return Intl.message(
      'Ongoing',
      name: 'ongoing',
      desc: '',
      args: [],
    );
  }

  /// `Finished`
  String get finished {
    return Intl.message(
      'Finished',
      name: 'finished',
      desc: '',
      args: [],
    );
  }

  /// `index`
  String get index {
    return Intl.message(
      'index',
      name: 'index',
      desc: '',
      args: [],
    );
  }

  /// `Initiator`
  String get initiator {
    return Intl.message(
      'Initiator',
      name: 'initiator',
      desc: '',
      args: [],
    );
  }

  /// `Selected`
  String get selected {
    return Intl.message(
      'Selected',
      name: 'selected',
      desc: '',
      args: [],
    );
  }

  /// `Investment amount`
  String get investment_amount {
    return Intl.message(
      'Investment amount',
      name: 'investment_amount',
      desc: '',
      args: [],
    );
  }

  /// `Inviter`
  String get inviter {
    return Intl.message(
      'Inviter',
      name: 'inviter',
      desc: '',
      args: [],
    );
  }

  /// `Inviter(Optional, must have participated in fundraising)`
  String get inviterOptional {
    return Intl.message(
      'Inviter(Optional, must have participated in fundraising)',
      name: 'inviterOptional',
      desc: '',
      args: [],
    );
  }

  /// `Reward `
  String get inviterTips1 {
    return Intl.message(
      'Reward ',
      name: 'inviterTips1',
      desc: '',
      args: [],
    );
  }

  /// `, you can get `
  String get inviterTips2 {
    return Intl.message(
      ', you can get ',
      name: 'inviterTips2',
      desc: '',
      args: [],
    );
  }

  /// `%, the inviter get `
  String get inviterTips3 {
    return Intl.message(
      '%, the inviter get ',
      name: 'inviterTips3',
      desc: '',
      args: [],
    );
  }

  /// `Participate in fundraising`
  String get ParticipateInFundraising {
    return Intl.message(
      'Participate in fundraising',
      name: 'ParticipateInFundraising',
      desc: '',
      args: [],
    );
  }

  /// `Template 1`
  String get template1 {
    return Intl.message(
      'Template 1',
      name: 'template1',
      desc: '',
      args: [],
    );
  }

  /// `Template 2`
  String get template2 {
    return Intl.message(
      'Template 2',
      name: 'template2',
      desc: '',
      args: [],
    );
  }

  /// `Change user min and max amount`
  String get changeUerMinMaxAmount {
    return Intl.message(
      'Change user min and max amount',
      name: 'changeUerMinMaxAmount',
      desc: '',
      args: [],
    );
  }

  /// `Projec info`
  String get projecInfo {
    return Intl.message(
      'Projec info',
      name: 'projecInfo',
      desc: '',
      args: [],
    );
  }

  /// `Raise info`
  String get raiseInfo {
    return Intl.message(
      'Raise info',
      name: 'raiseInfo',
      desc: '',
      args: [],
    );
  }

  /// `ICO info`
  String get ICOInfo {
    return Intl.message(
      'ICO info',
      name: 'ICOInfo',
      desc: '',
      args: [],
    );
  }

  /// `Project name`
  String get projectName {
    return Intl.message(
      'Project name',
      name: 'projectName',
      desc: '',
      args: [],
    );
  }

  /// `Progress rate`
  String get progressRate {
    return Intl.message(
      'Progress rate',
      name: 'progressRate',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Find token`
  String get findToken {
    return Intl.message(
      'Find token',
      name: 'findToken',
      desc: '',
      args: [],
    );
  }

  /// `Participated`
  String get participated {
    return Intl.message(
      'Participated',
      name: 'participated',
      desc: '',
      args: [],
    );
  }

  /// `Manage`
  String get manage {
    return Intl.message(
      'Manage',
      name: 'manage',
      desc: '',
      args: [],
    );
  }

  /// `Amount too high`
  String get amount_too_high {
    return Intl.message(
      'Amount too high',
      name: 'amount_too_high',
      desc: '',
      args: [],
    );
  }

  /// `Amount too low`
  String get amount_too_low {
    return Intl.message(
      'Amount too low',
      name: 'amount_too_low',
      desc: '',
      args: [],
    );
  }

  /// `Select area/country`
  String get selectArea {
    return Intl.message(
      'Select area/country',
      name: 'selectArea',
      desc: '',
      args: [],
    );
  }

  /// `Validating`
  String get validating {
    return Intl.message(
      'Validating',
      name: 'validating',
      desc: '',
      args: [],
    );
  }

  /// `Raise token ID error`
  String get exchangeTokenError {
    return Intl.message(
      'Raise token ID error',
      name: 'exchangeTokenError',
      desc: '',
      args: [],
    );
  }

  /// `Less then min amount`
  String get userMaxAmountError {
    return Intl.message(
      'Less then min amount',
      name: 'userMaxAmountError',
      desc: '',
      args: [],
    );
  }

  /// `Exceed the chain assets `
  String get totalIcoAmountError {
    return Intl.message(
      'Exceed the chain assets ',
      name: 'totalIcoAmountError',
      desc: '',
      args: [],
    );
  }

  /// `Exceed total issuance`
  String get totalCirculationError {
    return Intl.message(
      'Exceed total issuance',
      name: 'totalCirculationError',
      desc: '',
      args: [],
    );
  }

  /// `Amount is too high`
  String get amountTooHigh {
    return Intl.message(
      'Amount is too high',
      name: 'amountTooHigh',
      desc: '',
      args: [],
    );
  }

  /// `Raise token ID not find!`
  String get exchangeTokenIdNotFind {
    return Intl.message(
      'Raise token ID not find!',
      name: 'exchangeTokenIdNotFind',
      desc: '',
      args: [],
    );
  }

  /// `Currency id not find!`
  String get currencyIdNotFind {
    return Intl.message(
      'Currency id not find!',
      name: 'currencyIdNotFind',
      desc: '',
      args: [],
    );
  }

  /// `Try it later!`
  String get tryItLater {
    return Intl.message(
      'Try it later!',
      name: 'tryItLater',
      desc: '',
      args: [],
    );
  }

  /// `Currency id`
  String get currencyId {
    return Intl.message(
      'Currency id',
      name: 'currencyId',
      desc: '',
      args: [],
    );
  }

  /// `Logo url`
  String get logoUrl {
    return Intl.message(
      'Logo url',
      name: 'logoUrl',
      desc: '',
      args: [],
    );
  }

  /// `Official website`
  String get officialWebsite {
    return Intl.message(
      'Official website',
      name: 'officialWebsite',
      desc: '',
      args: [],
    );
  }

  /// ` (https://...)`
  String get https {
    return Intl.message(
      ' (https://...)',
      name: 'https',
      desc: '',
      args: [],
    );
  }

  /// `Change max times of users in ICO`
  String get changeUserIcoMaxTimes {
    return Intl.message(
      'Change max times of users in ICO',
      name: 'changeUserIcoMaxTimes',
      desc: '',
      args: [],
    );
  }

  /// `Max times of users participating in ICO`
  String get userIcoMaxTimes {
    return Intl.message(
      'Max times of users participating in ICO',
      name: 'userIcoMaxTimes',
      desc: '',
      args: [],
    );
  }

  /// `Is must kyc`
  String get isMustKyc {
    return Intl.message(
      'Is must kyc',
      name: 'isMustKyc',
      desc: '',
      args: [],
    );
  }

  /// `Total issuance`
  String get totalIssuance {
    return Intl.message(
      'Total issuance',
      name: 'totalIssuance',
      desc: '',
      args: [],
    );
  }

  /// `Total circulation`
  String get totalCirculation {
    return Intl.message(
      'Total circulation',
      name: 'totalCirculation',
      desc: '',
      args: [],
    );
  }

  /// `ICO duration (days)`
  String get icoDuration {
    return Intl.message(
      'ICO duration (days)',
      name: 'icoDuration',
      desc: '',
      args: [],
    );
  }

  /// `Total ICO amount`
  String get totalIcoAmount {
    return Intl.message(
      'Total ICO amount',
      name: 'totalIcoAmount',
      desc: '',
      args: [],
    );
  }

  /// `User min participating amount`
  String get userMinAmount {
    return Intl.message(
      'User min participating amount',
      name: 'userMinAmount',
      desc: '',
      args: [],
    );
  }

  /// `User max participating amount`
  String get userMaxAmount {
    return Intl.message(
      'User max participating amount',
      name: 'userMaxAmount',
      desc: '',
      args: [],
    );
  }

  /// `Raise token`
  String get exchangeToken {
    return Intl.message(
      'Raise token',
      name: 'exchangeToken',
      desc: '',
      args: [],
    );
  }

  /// `Raise token ID`
  String get exchangeTokenId {
    return Intl.message(
      'Raise token ID',
      name: 'exchangeTokenId',
      desc: '',
      args: [],
    );
  }

  /// `Total raise token amount`
  String get exchangeTokenTotalAmount {
    return Intl.message(
      'Total raise token amount',
      name: 'exchangeTokenTotalAmount',
      desc: '',
      args: [],
    );
  }

  /// `Regions/countries prohibited to participate`
  String get excludeArea {
    return Intl.message(
      'Regions/countries prohibited to participate',
      name: 'excludeArea',
      desc: '',
      args: [],
    );
  }

  /// `Participating user lock-up proportion`
  String get lockProportion {
    return Intl.message(
      'Participating user lock-up proportion',
      name: 'lockProportion',
      desc: '',
      args: [],
    );
  }

  /// `Unlock duration(days)`
  String get unlockDuration {
    return Intl.message(
      'Unlock duration(days)',
      name: 'unlockDuration',
      desc: '',
      args: [],
    );
  }

  /// `Unlocks per duration`
  String get perDurationUnlockAmount {
    return Intl.message(
      'Unlocks per duration',
      name: 'perDurationUnlockAmount',
      desc: '',
      args: [],
    );
  }

  /// `ICO infomation`
  String get ico_infomation {
    return Intl.message(
      'ICO infomation',
      name: 'ico_infomation',
      desc: '',
      args: [],
    );
  }

  /// `Add project`
  String get add_project {
    return Intl.message(
      'Add project',
      name: 'add_project',
      desc: '',
      args: [],
    );
  }

  /// `Certification list`
  String get certificationList {
    return Intl.message(
      'Certification list',
      name: 'certificationList',
      desc: '',
      args: [],
    );
  }

  /// `SwordHolder`
  String get swordHolder {
    return Intl.message(
      'SwordHolder',
      name: 'swordHolder',
      desc: '',
      args: [],
    );
  }

  /// `Front of ID card or passport`
  String get front_kyc_info {
    return Intl.message(
      'Front of ID card or passport',
      name: 'front_kyc_info',
      desc: '',
      args: [],
    );
  }

  /// `Back of ID card or passport`
  String get back_kyc_info {
    return Intl.message(
      'Back of ID card or passport',
      name: 'back_kyc_info',
      desc: '',
      args: [],
    );
  }

  /// `Judgement`
  String get judgement {
    return Intl.message(
      'Judgement',
      name: 'judgement',
      desc: '',
      args: [],
    );
  }

  /// `KYC info ID`
  String get kyc_info_id {
    return Intl.message(
      'KYC info ID',
      name: 'kyc_info_id',
      desc: '',
      args: [],
    );
  }

  /// `Image load error`
  String get image_load_error {
    return Intl.message(
      'Image load error',
      name: 'image_load_error',
      desc: '',
      args: [],
    );
  }

  /// `Audit`
  String get audit {
    return Intl.message(
      'Audit',
      name: 'audit',
      desc: '',
      args: [],
    );
  }

  /// `Audit list`
  String get audit_list {
    return Intl.message(
      'Audit list',
      name: 'audit_list',
      desc: '',
      args: [],
    );
  }

  /// `Get KYC image hash`
  String get get_kyc_imageHash {
    return Intl.message(
      'Get KYC image hash',
      name: 'get_kyc_imageHash',
      desc: '',
      args: [],
    );
  }

  /// `Please take a picture as shown. Hold the ID card or passport in the left hand and the paper in the right hand, and write the following information on the paper:`
  String get kyc_info_upload_tip1 {
    return Intl.message(
      'Please take a picture as shown. Hold the ID card or passport in the left hand and the paper in the right hand, and write the following information on the paper:',
      name: 'kyc_info_upload_tip1',
      desc: '',
      args: [],
    );
  }

  /// `ID Number: your card ID   current date (eg: 2022-02-22)   request RID certification`
  String get kyc_info_upload_tip2 {
    return Intl.message(
      'ID Number: your card ID   current date (eg: 2022-02-22)   request RID certification',
      name: 'kyc_info_upload_tip2',
      desc: '',
      args: [],
    );
  }

  /// `Tip: Your personal information picture will be uploaded to the IPFS network (this is safe, because the picture hash will not be saved on the chain or any storage. Your picture hash will be encrypted to get the message, and this message will be saved on the chain , Only you and IAS can decrypt the message and get the picture hash).`
  String get tips_kyc_info {
    return Intl.message(
      'Tip: Your personal information picture will be uploaded to the IPFS network (this is safe, because the picture hash will not be saved on the chain or any storage. Your picture hash will be encrypted to get the message, and this message will be saved on the chain , Only you and IAS can decrypt the message and get the picture hash).',
      name: 'tips_kyc_info',
      desc: '',
      args: [],
    );
  }

  /// `Encrypted message`
  String get kyc_message {
    return Intl.message(
      'Encrypted message',
      name: 'kyc_message',
      desc: '',
      args: [],
    );
  }

  /// `Request judgement`
  String get requestJudgement {
    return Intl.message(
      'Request judgement',
      name: 'requestJudgement',
      desc: '',
      args: [],
    );
  }

  /// `Recommend`
  String get recommend {
    return Intl.message(
      'Recommend',
      name: 'recommend',
      desc: '',
      args: [],
    );
  }

  /// `Max application fee`
  String get max_fee {
    return Intl.message(
      'Max application fee',
      name: 'max_fee',
      desc: '',
      args: [],
    );
  }

  /// `Fileds`
  String get fileds {
    return Intl.message(
      'Fileds',
      name: 'fileds',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to clear all KYC information?`
  String get clear_kyc {
    return Intl.message(
      'Are you sure to clear all KYC information?',
      name: 'clear_kyc',
      desc: '',
      args: [],
    );
  }

  /// `KYC info`
  String get KYC_info {
    return Intl.message(
      'KYC info',
      name: 'KYC_info',
      desc: '',
      args: [],
    );
  }

  /// `Certification`
  String get certification {
    return Intl.message(
      'Certification',
      name: 'certification',
      desc: '',
      args: [],
    );
  }

  /// `Apply certification`
  String get applyCertification {
    return Intl.message(
      'Apply certification',
      name: 'applyCertification',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Area/country`
  String get area {
    return Intl.message(
      'Area/country',
      name: 'area',
      desc: '',
      args: [],
    );
  }

  /// `Generate`
  String get generate {
    return Intl.message(
      'Generate',
      name: 'generate',
      desc: '',
      args: [],
    );
  }

  /// `Curve public key`
  String get curvePublicKey {
    return Intl.message(
      'Curve public key',
      name: 'curvePublicKey',
      desc: '',
      args: [],
    );
  }

  /// `Please upload a file larger than 10kb`
  String get over_size {
    return Intl.message(
      'Please upload a file larger than 10kb',
      name: 'over_size',
      desc: '',
      args: [],
    );
  }

  /// `Please upload a file less than 20Mb`
  String get less_size {
    return Intl.message(
      'Please upload a file less than 20Mb',
      name: 'less_size',
      desc: '',
      args: [],
    );
  }

  /// `Failed, try again later or change IPFS node`
  String get upload_retry {
    return Intl.message(
      'Failed, try again later or change IPFS node',
      name: 'upload_retry',
      desc: '',
      args: [],
    );
  }

  /// `Click upload`
  String get click_upload {
    return Intl.message(
      'Click upload',
      name: 'click_upload',
      desc: '',
      args: [],
    );
  }

  /// `Set KYC`
  String get set_kyc {
    return Intl.message(
      'Set KYC',
      name: 'set_kyc',
      desc: '',
      args: [],
    );
  }

  /// `ICO platform for decentralized auto organization`
  String get appDesc1 {
    return Intl.message(
      'ICO platform for decentralized auto organization',
      name: 'appDesc1',
      desc: '',
      args: [],
    );
  }

  /// `DICO stands for DAO + ICO + Swap. DICO is positioned as a parachain of decentralized ICO. Meanwhile, it has the function of token exchange to promote the faster development of Polkadot.`
  String get appDesc2 {
    return Intl.message(
      'DICO stands for DAO + ICO + Swap. DICO is positioned as a parachain of decentralized ICO. Meanwhile, it has the function of token exchange to promote the faster development of Polkadot.',
      name: 'appDesc2',
      desc: '',
      args: [],
    );
  }

  /// `Add custom types`
  String get add_custom_types {
    return Intl.message(
      'Add custom types',
      name: 'add_custom_types',
      desc: '',
      args: [],
    );
  }

  /// `keep-alive`
  String get transfer_alive {
    return Intl.message(
      'keep-alive',
      name: 'transfer_alive',
      desc: '',
      args: [],
    );
  }

  /// `With the keep-alive option set, the account is protected against removal due to low balances.`
  String get transfer_alive_msg {
    return Intl.message(
      'With the keep-alive option set, the account is protected against removal due to low balances.',
      name: 'transfer_alive_msg',
      desc: '',
      args: [],
    );
  }

  /// `Max`
  String get amount_max {
    return Intl.message(
      'Max',
      name: 'amount_max',
      desc: '',
      args: [],
    );
  }

  /// `existential deposit`
  String get amount_exist {
    return Intl.message(
      'existential deposit',
      name: 'amount_exist',
      desc: '',
      args: [],
    );
  }

  /// `\nThe minimum amount that an account should have to be deemed active.\n`
  String get amount_exist_msg {
    return Intl.message(
      '\nThe minimum amount that an account should have to be deemed active.\n',
      name: 'amount_exist_msg',
      desc: '',
      args: [],
    );
  }

  /// `estimated transfer fee`
  String get amount_fee {
    return Intl.message(
      'estimated transfer fee',
      name: 'amount_fee',
      desc: '',
      args: [],
    );
  }

  /// `Custom Types`
  String get custom_types {
    return Intl.message(
      'Custom Types',
      name: 'custom_types',
      desc: '',
      args: [],
    );
  }

  /// `home`
  String get home {
    return Intl.message(
      'home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Tips`
  String get tips {
    return Intl.message(
      'Tips',
      name: 'tips',
      desc: '',
      args: [],
    );
  }

  /// `It is required`
  String get required {
    return Intl.message(
      'It is required',
      name: 'required',
      desc: '',
      args: [],
    );
  }

  /// `Failed to get exchange rate, please exit and try again`
  String get getPairFailed {
    return Intl.message(
      'Failed to get exchange rate, please exit and try again',
      name: 'getPairFailed',
      desc: '',
      args: [],
    );
  }

  /// `Error!`
  String get error {
    return Intl.message(
      'Error!',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Not support fingerprint`
  String get not_support_fingerprint {
    return Intl.message(
      'Not support fingerprint',
      name: 'not_support_fingerprint',
      desc: '',
      args: [],
    );
  }

  /// `Network connection error! Please check the network!`
  String get inteInfoError {
    return Intl.message(
      'Network connection error! Please check the network!',
      name: 'inteInfoError',
      desc: '',
      args: [],
    );
  }

  /// `Downloaded. Do you want to restart the app?`
  String get dowloadCompleted {
    return Intl.message(
      'Downloaded. Do you want to restart the app?',
      name: 'dowloadCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Update available`
  String get appStoreDowload {
    return Intl.message(
      'Update available',
      name: 'appStoreDowload',
      desc: '',
      args: [],
    );
  }

  /// `Update content`
  String get updateContent {
    return Intl.message(
      'Update content',
      name: 'updateContent',
      desc: '',
      args: [],
    );
  }

  /// `Update now`
  String get updateNow {
    return Intl.message(
      'Update now',
      name: 'updateNow',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get downloadNow {
    return Intl.message(
      'Download',
      name: 'downloadNow',
      desc: '',
      args: [],
    );
  }

  /// `Automatic installation failed, please install manually!`
  String get autoInstallFail {
    return Intl.message(
      'Automatic installation failed, please install manually!',
      name: 'autoInstallFail',
      desc: '',
      args: [],
    );
  }

  /// `Need enough permissions, please grant storage permissions and try again!`
  String get permissionFail {
    return Intl.message(
      'Need enough permissions, please grant storage permissions and try again!',
      name: 'permissionFail',
      desc: '',
      args: [],
    );
  }

  /// `Silent update in the background`
  String get updateBehand {
    return Intl.message(
      'Silent update in the background',
      name: 'updateBehand',
      desc: '',
      args: [],
    );
  }

  /// `Detected a new available version `
  String get newVersionFind {
    return Intl.message(
      'Detected a new available version ',
      name: 'newVersionFind',
      desc: '',
      args: [],
    );
  }

  /// `,Download it?\n\n`
  String get isDowload {
    return Intl.message(
      ',Download it?\n\n',
      name: 'isDowload',
      desc: '',
      args: [],
    );
  }

  /// `Delete It?\n\n`
  String get deleteIt {
    return Intl.message(
      'Delete It?\n\n',
      name: 'deleteIt',
      desc: '',
      args: [],
    );
  }

  /// `Transaction`
  String get transaction {
    return Intl.message(
      'Transaction',
      name: 'transaction',
      desc: '',
      args: [],
    );
  }

  /// `Bill`
  String get bill {
    return Intl.message(
      'Bill',
      name: 'bill',
      desc: '',
      args: [],
    );
  }

  /// `Statistics`
  String get statistics {
    return Intl.message(
      'Statistics',
      name: 'statistics',
      desc: '',
      args: [],
    );
  }

  /// `Assets`
  String get assets {
    return Intl.message(
      'Assets',
      name: 'assets',
      desc: '',
      args: [],
    );
  }

  /// `Deposit & Earn`
  String get deposit_earn {
    return Intl.message(
      'Deposit & Earn',
      name: 'deposit_earn',
      desc: '',
      args: [],
    );
  }

  /// `Deposit your digital assets and stable coins into the liquid pool to earn interests and rewards`
  String get deposit_earn_desc {
    return Intl.message(
      'Deposit your digital assets and stable coins into the liquid pool to earn interests and rewards',
      name: 'deposit_earn_desc',
      desc: '',
      args: [],
    );
  }

  /// `Loan`
  String get loan {
    return Intl.message(
      'Loan',
      name: 'loan',
      desc: '',
      args: [],
    );
  }

  /// `Governance`
  String get governance {
    return Intl.message(
      'Governance',
      name: 'governance',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menu {
    return Intl.message(
      'Menu',
      name: 'menu',
      desc: '',
      args: [],
    );
  }

  /// `Scan`
  String get scan {
    return Intl.message(
      'Scan',
      name: 'scan',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get create {
    return Intl.message(
      'Create Account',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `Import Account`
  String get import {
    return Intl.message(
      'Import Account',
      name: 'import',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get password2 {
    return Intl.message(
      'Confirm Password',
      name: 'password2',
      desc: '',
      args: [],
    );
  }

  /// `Next Step`
  String get next {
    return Intl.message(
      'Next Step',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Sign and Submit`
  String get submit_send {
    return Intl.message(
      'Sign and Submit',
      name: 'submit_send',
      desc: '',
      args: [],
    );
  }

  /// `Submit (no sign)`
  String get submit_no_sign {
    return Intl.message(
      'Submit (no sign)',
      name: 'submit_no_sign',
      desc: '',
      args: [],
    );
  }

  /// `Submit Transaction`
  String get submit_tx {
    return Intl.message(
      'Submit Transaction',
      name: 'submit_tx',
      desc: '',
      args: [],
    );
  }

  /// `You are about to sign a transaction from `
  String get submit_from {
    return Intl.message(
      'You are about to sign a transaction from ',
      name: 'submit_from',
      desc: '',
      args: [],
    );
  }

  /// `Calling `
  String get submit_call {
    return Intl.message(
      'Calling ',
      name: 'submit_call',
      desc: '',
      args: [],
    );
  }

  /// `Fees`
  String get submit_fees {
    return Intl.message(
      'Fees',
      name: 'submit_fees',
      desc: '',
      args: [],
    );
  }

  /// `Unlock Account with Password`
  String get unlock_account {
    return Intl.message(
      'Unlock Account with Password',
      name: 'unlock_account',
      desc: '',
      args: [],
    );
  }

  /// `Queued`
  String get tx_queued {
    return Intl.message(
      'Queued',
      name: 'tx_queued',
      desc: '',
      args: [],
    );
  }

  /// `Sign`
  String get submit_sign {
    return Intl.message(
      'Sign',
      name: 'submit_sign',
      desc: '',
      args: [],
    );
  }

  /// `Sign Tx`
  String get submit_sign_tx {
    return Intl.message(
      'Sign Tx',
      name: 'submit_sign_tx',
      desc: '',
      args: [],
    );
  }

  /// `Sign Message`
  String get submit_sign_msg {
    return Intl.message(
      'Sign Message',
      name: 'submit_sign_msg',
      desc: '',
      args: [],
    );
  }

  /// `Signer`
  String get submit_signer {
    return Intl.message(
      'Signer',
      name: 'submit_signer',
      desc: '',
      args: [],
    );
  }

  /// `Sign via QR`
  String get submit_qr {
    return Intl.message(
      'Sign via QR',
      name: 'submit_qr',
      desc: '',
      args: [],
    );
  }

  /// `Authenticate to unlock`
  String get unlock_bio {
    return Intl.message(
      'Authenticate to unlock',
      name: 'unlock_bio',
      desc: '',
      args: [],
    );
  }

  /// `Enable fingerprint/faceID`
  String get unlock_bio_enable {
    return Intl.message(
      'Enable fingerprint/faceID',
      name: 'unlock_bio_enable',
      desc: '',
      args: [],
    );
  }

  /// `Waiting`
  String get tx_wait {
    return Intl.message(
      'Waiting',
      name: 'tx_wait',
      desc: '',
      args: [],
    );
  }

  /// `Ready`
  String get tx_Ready {
    return Intl.message(
      'Ready',
      name: 'tx_Ready',
      desc: '',
      args: [],
    );
  }

  /// `Broadcast`
  String get tx_Broadcast {
    return Intl.message(
      'Broadcast',
      name: 'tx_Broadcast',
      desc: '',
      args: [],
    );
  }

  /// `Inblock`
  String get tx_Inblock {
    return Intl.message(
      'Inblock',
      name: 'tx_Inblock',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get tx_error {
    return Intl.message(
      'Error',
      name: 'tx_error',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Detail`
  String get detail {
    return Intl.message(
      'Detail',
      name: 'detail',
      desc: '',
      args: [],
    );
  }

  /// `Tx Submitted`
  String get notify_submitted {
    return Intl.message(
      'Tx Submitted',
      name: 'notify_submitted',
      desc: '',
      args: [],
    );
  }

  /// `No Data`
  String get data_empty {
    return Intl.message(
      'No Data',
      name: 'data_empty',
      desc: '',
      args: [],
    );
  }

  /// `Copy to clipboard`
  String get copyToClipboard {
    return Intl.message(
      'Copy to clipboard',
      name: 'copyToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `Select Wallet`
  String get setting_network {
    return Intl.message(
      'Select Wallet',
      name: 'setting_network',
      desc: '',
      args: [],
    );
  }

  /// `Acala`
  String get acala {
    return Intl.message(
      'Acala',
      name: 'acala',
      desc: '',
      args: [],
    );
  }

  /// `Flow`
  String get flow {
    return Intl.message(
      'Flow',
      name: 'flow',
      desc: '',
      args: [],
    );
  }

  /// `Check Update`
  String get update {
    return Intl.message(
      'Check Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Your App is the newest version.`
  String get update_latest {
    return Intl.message(
      'Your App is the newest version.',
      name: 'update_latest',
      desc: '',
      args: [],
    );
  }

  /// `New version found, update now?`
  String get update_up {
    return Intl.message(
      'New version found, update now?',
      name: 'update_up',
      desc: '',
      args: [],
    );
  }

  /// `Connecting ...`
  String get update_start {
    return Intl.message(
      'Connecting ...',
      name: 'update_start',
      desc: '',
      args: [],
    );
  }

  /// `Downloading ...`
  String get update_download {
    return Intl.message(
      'Downloading ...',
      name: 'update_download',
      desc: '',
      args: [],
    );
  }

  /// `Installing ...`
  String get update_install {
    return Intl.message(
      'Installing ...',
      name: 'update_install',
      desc: '',
      args: [],
    );
  }

  /// `Update Failed`
  String get update_error {
    return Intl.message(
      'Update Failed',
      name: 'update_error',
      desc: '',
      args: [],
    );
  }

  /// `Metadata needs to be updated to continue.`
  String get update_js_up {
    return Intl.message(
      'Metadata needs to be updated to continue.',
      name: 'update_js_up',
      desc: '',
      args: [],
    );
  }

  /// `Invalid input`
  String get input_invalid {
    return Intl.message(
      'Invalid input',
      name: 'input_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Loading ...`
  String get loading {
    return Intl.message(
      'Loading ...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Announcement`
  String get announce {
    return Intl.message(
      'Announcement',
      name: 'announce',
      desc: '',
      args: [],
    );
  }

  /// `My`
  String get my {
    return Intl.message(
      'My',
      name: 'my',
      desc: '',
      args: [],
    );
  }

  /// `No valid QR code detected`
  String get description {
    return Intl.message(
      'No valid QR code detected',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `No valid QR code detected`
  String get noValidQR {
    return Intl.message(
      'No valid QR code detected',
      name: 'noValidQR',
      desc: '',
      args: [],
    );
  }

  /// `Flash`
  String get flashlight {
    return Intl.message(
      'Flash',
      name: 'flashlight',
      desc: '',
      args: [],
    );
  }

  /// `No camara premission`
  String get noCamaraPremission {
    return Intl.message(
      'No camara premission',
      name: 'noCamaraPremission',
      desc: '',
      args: [],
    );
  }

  /// `Node Connect Failed`
  String get nodeConnectFailed {
    return Intl.message(
      'Node Connect Failed',
      name: 'nodeConnectFailed',
      desc: '',
      args: [],
    );
  }

  /// `Node Connecting ...`
  String get nodeConnecting {
    return Intl.message(
      'Node Connecting ...',
      name: 'nodeConnecting',
      desc: '',
      args: [],
    );
  }

  /// `Not available`
  String get notAvailable {
    return Intl.message(
      'Not available',
      name: 'notAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Other operating system`
  String get otherOperatingSystem {
    return Intl.message(
      'Other operating system',
      name: 'otherOperatingSystem',
      desc: '',
      args: [],
    );
  }

  /// `Not enrolled`
  String get notEnrolled {
    return Intl.message(
      'Not enrolled',
      name: 'notEnrolled',
      desc: '',
      args: [],
    );
  }

  /// `Locked out`
  String get lockedOut {
    return Intl.message(
      'Locked out',
      name: 'lockedOut',
      desc: '',
      args: [],
    );
  }

  /// `Permanently locked out`
  String get permanentlyLockedOut {
    return Intl.message(
      'Permanently locked out',
      name: 'permanentlyLockedOut',
      desc: '',
      args: [],
    );
  }

  /// `Auth in progress`
  String get auth_in_progress {
    return Intl.message(
      'Auth in progress',
      name: 'auth_in_progress',
      desc: '',
      args: [],
    );
  }

  /// `My Account Address`
  String get myAccountAddress {
    return Intl.message(
      'My Account Address',
      name: 'myAccountAddress',
      desc: '',
      args: [],
    );
  }

  /// `Manage Account`
  String get manageAccount {
    return Intl.message(
      'Manage Account',
      name: 'manageAccount',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get setting {
    return Intl.message(
      'Setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Total Assets`
  String get totalAssets {
    return Intl.message(
      'Total Assets',
      name: 'totalAssets',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Staking`
  String get staking {
    return Intl.message(
      'Staking',
      name: 'staking',
      desc: '',
      args: [],
    );
  }

  /// `Council`
  String get council {
    return Intl.message(
      'Council',
      name: 'council',
      desc: '',
      args: [],
    );
  }

  /// `Treasury`
  String get treasury {
    return Intl.message(
      'Treasury',
      name: 'treasury',
      desc: '',
      args: [],
    );
  }

  /// `Democracy`
  String get democracy {
    return Intl.message(
      'Democracy',
      name: 'democracy',
      desc: '',
      args: [],
    );
  }

  /// `ChangeName`
  String get changeName {
    return Intl.message(
      'ChangeName',
      name: 'changeName',
      desc: '',
      args: [],
    );
  }

  /// `ChangePassword`
  String get changePassword {
    return Intl.message(
      'ChangePassword',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `ExportKeystore`
  String get exportKeystore {
    return Intl.message(
      'ExportKeystore',
      name: 'exportKeystore',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Add addresses`
  String get addAddresses {
    return Intl.message(
      'Add addresses',
      name: 'addAddresses',
      desc: '',
      args: [],
    );
  }

  /// `Do not add your own addresses`
  String get doNotAddYourOwnAddresses {
    return Intl.message(
      'Do not add your own addresses',
      name: 'doNotAddYourOwnAddresses',
      desc: '',
      args: [],
    );
  }

  /// `Addresses`
  String get addresses {
    return Intl.message(
      'Addresses',
      name: 'addresses',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Save Success`
  String get saveSuccess {
    return Intl.message(
      'Save Success',
      name: 'saveSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Delete Address ?`
  String get deleteAddress {
    return Intl.message(
      'Delete Address ?',
      name: 'deleteAddress',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get active {
    return Intl.message(
      'Available',
      name: 'active',
      desc: '',
      args: [],
    );
  }

  /// `Checking`
  String get checking {
    return Intl.message(
      'Checking',
      name: 'checking',
      desc: '',
      args: [],
    );
  }

  /// `Unavailable`
  String get inActive {
    return Intl.message(
      'Unavailable',
      name: 'inActive',
      desc: '',
      args: [],
    );
  }

  /// `(Optional)`
  String get optional {
    return Intl.message(
      '(Optional)',
      name: 'optional',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Confirm deleting this account ?`
  String get deleteTip {
    return Intl.message(
      'Confirm deleting this account ?',
      name: 'deleteTip',
      desc: '',
      args: [],
    );
  }

  /// `Delete success`
  String get deleteSuccess {
    return Intl.message(
      'Delete success',
      name: 'deleteSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password to unlock`
  String get unlockPassword {
    return Intl.message(
      'Please enter your password to unlock',
      name: 'unlockPassword',
      desc: '',
      args: [],
    );
  }

  /// `Input your password to confirm`
  String get inputPasswordConfirm {
    return Intl.message(
      'Input your password to confirm',
      name: 'inputPasswordConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Please save your KeyStore information`
  String get saveInformation {
    return Intl.message(
      'Please save your KeyStore information',
      name: 'saveInformation',
      desc: '',
      args: [],
    );
  }

  /// `Download finished, whether to restart the application?`
  String get restartApp {
    return Intl.message(
      'Download finished, whether to restart the application?',
      name: 'restartApp',
      desc: '',
      args: [],
    );
  }

  /// `Update failed.`
  String get updateFailed {
    return Intl.message(
      'Update failed.',
      name: 'updateFailed',
      desc: '',
      args: [],
    );
  }

  /// `Your application version has been updated, please go to the official website to download the new version.`
  String get toAppStore {
    return Intl.message(
      'Your application version has been updated, please go to the official website to download the new version.',
      name: 'toAppStore',
      desc: '',
      args: [],
    );
  }

  /// `You can try downloading the latest version on the official website.`
  String get gotoAppStore {
    return Intl.message(
      'You can try downloading the latest version on the official website.',
      name: 'gotoAppStore',
      desc: '',
      args: [],
    );
  }

  /// `Your application version is up to date.`
  String get appV {
    return Intl.message(
      'Your application version is up to date.',
      name: 'appV',
      desc: '',
      args: [],
    );
  }

  /// `Check the new version:`
  String get checkNewV {
    return Intl.message(
      'Check the new version:',
      name: 'checkNewV',
      desc: '',
      args: [],
    );
  }

  /// `whether to download?`
  String get download {
    return Intl.message(
      'whether to download?',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `Next startup time`
  String get nextTime {
    return Intl.message(
      'Next startup time',
      name: 'nextTime',
      desc: '',
      args: [],
    );
  }

  /// `The gesture password has been canceled`
  String get gestureCanceled {
    return Intl.message(
      'The gesture password has been canceled',
      name: 'gestureCanceled',
      desc: '',
      args: [],
    );
  }

  /// `The Fingerprint/Face password has been canceled`
  String get touchCanceled {
    return Intl.message(
      'The Fingerprint/Face password has been canceled',
      name: 'touchCanceled',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Gesture`
  String get gesture {
    return Intl.message(
      'Gesture',
      name: 'gesture',
      desc: '',
      args: [],
    );
  }

  /// `TouchID/FaceID`
  String get touchId {
    return Intl.message(
      'TouchID/FaceID',
      name: 'touchId',
      desc: '',
      args: [],
    );
  }

  /// `Remote Node`
  String get remoteNode {
    return Intl.message(
      'Remote Node',
      name: 'remoteNode',
      desc: '',
      args: [],
    );
  }

  /// `Check Update`
  String get checkUpdate {
    return Intl.message(
      'Check Update',
      name: 'checkUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Delete gesture password ?`
  String get deleteGp {
    return Intl.message(
      'Delete gesture password ?',
      name: 'deleteGp',
      desc: '',
      args: [],
    );
  }

  /// `Delete fingerprint/face password ?`
  String get deleteTouch {
    return Intl.message(
      'Delete fingerprint/face password ?',
      name: 'deleteTouch',
      desc: '',
      args: [],
    );
  }

  /// `Your device does not support or open Touch ID, Face ID`
  String get noTouchId {
    return Intl.message(
      'Your device does not support or open Touch ID, Face ID',
      name: 'noTouchId',
      desc: '',
      args: [],
    );
  }

  /// `Authentication Required`
  String get authentication {
    return Intl.message(
      'Authentication Required',
      name: 'authentication',
      desc: '',
      args: [],
    );
  }

  /// `Authenticated Successfully`
  String get authenticatedSuccess {
    return Intl.message(
      'Authenticated Successfully',
      name: 'authenticatedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Authentication Failed`
  String get authenticatedError {
    return Intl.message(
      'Authentication Failed',
      name: 'authenticatedError',
      desc: '',
      args: [],
    );
  }

  /// `New name`
  String get newName {
    return Intl.message(
      'New name',
      name: 'newName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your current password`
  String get entPwd {
    return Intl.message(
      'Please enter your current password',
      name: 'entPwd',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your new name`
  String get entName {
    return Intl.message(
      'Please enter your new name',
      name: 'entName',
      desc: '',
      args: [],
    );
  }

  /// `Current password`
  String get currentPassword {
    return Intl.message(
      'Current password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get newPassword {
    return Intl.message(
      'New password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Repeat password`
  String get repeatPassword {
    return Intl.message(
      'Repeat password',
      name: 'repeatPassword',
      desc: '',
      args: [],
    );
  }

  /// `The new password does not match the confirmation password`
  String get passwordNotMatch {
    return Intl.message(
      'The new password does not match the confirmation password',
      name: 'passwordNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `The two passwords are different`
  String get differentPassword {
    return Intl.message(
      'The two passwords are different',
      name: 'differentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully`
  String get modify {
    return Intl.message(
      'Password changed successfully',
      name: 'modify',
      desc: '',
      args: [],
    );
  }

  /// `Password mistake`
  String get passwordMistake {
    return Intl.message(
      'Password mistake',
      name: 'passwordMistake',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Please set the gesture password.`
  String get setGesture {
    return Intl.message(
      'Please set the gesture password.',
      name: 'setGesture',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm the gesture password.`
  String get confirmGesture {
    return Intl.message(
      'Please confirm the gesture password.',
      name: 'confirmGesture',
      desc: '',
      args: [],
    );
  }

  /// `Confirmed, password set successfully.`
  String get gestureSuccess {
    return Intl.message(
      'Confirmed, password set successfully.',
      name: 'gestureSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation failed, please reset.`
  String get gestureFailed {
    return Intl.message(
      'Confirmation failed, please reset.',
      name: 'gestureFailed',
      desc: '',
      args: [],
    );
  }

  /// `Please input your password.`
  String get inputPwd {
    return Intl.message(
      'Please input your password.',
      name: 'inputPwd',
      desc: '',
      args: [],
    );
  }

  /// `Please input your password (again).`
  String get inputPwdD {
    return Intl.message(
      'Please input your password (again).',
      name: 'inputPwdD',
      desc: '',
      args: [],
    );
  }

  /// `Set Node`
  String get setNode {
    return Intl.message(
      'Set Node',
      name: 'setNode',
      desc: '',
      args: [],
    );
  }

  /// `Custom Node`
  String get customNode {
    return Intl.message(
      'Custom Node',
      name: 'customNode',
      desc: '',
      args: [],
    );
  }

  /// `Desc`
  String get desc {
    return Intl.message(
      'Desc',
      name: 'desc',
      desc: '',
      args: [],
    );
  }

  /// `Wrong format`
  String get formatMistake {
    return Intl.message(
      'Wrong format',
      name: 'formatMistake',
      desc: '',
      args: [],
    );
  }

  /// `Select your Node`
  String get selectNode {
    return Intl.message(
      'Select your Node',
      name: 'selectNode',
      desc: '',
      args: [],
    );
  }

  /// `Custom`
  String get custom {
    return Intl.message(
      'Custom',
      name: 'custom',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Clear Custom Nodes`
  String get clearCustomNodes {
    return Intl.message(
      'Clear Custom Nodes',
      name: 'clearCustomNodes',
      desc: '',
      args: [],
    );
  }

  /// `Make sure you change Node to:`
  String get changeNode {
    return Intl.message(
      'Make sure you change Node to:',
      name: 'changeNode',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Choose the remote node`
  String get notetip1 {
    return Intl.message(
      'Choose the remote node',
      name: 'notetip1',
      desc: '',
      args: [],
    );
  }

  /// `NOTE: Exit the app,will return to the default`
  String get notetip2 {
    return Intl.message(
      'NOTE: Exit the app,will return to the default',
      name: 'notetip2',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your custom Node (wss://ip or ws://ip)`
  String get enterNode {
    return Intl.message(
      'Please enter your custom Node (wss://ip or ws://ip)',
      name: 'enterNode',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Memo`
  String get memo {
    return Intl.message(
      'Memo',
      name: 'memo',
      desc: '',
      args: [],
    );
  }

  /// `Fee`
  String get fee {
    return Intl.message(
      'Fee',
      name: 'fee',
      desc: '',
      args: [],
    );
  }

  /// `Sale Tax`
  String get saleTax {
    return Intl.message(
      'Sale Tax',
      name: 'saleTax',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter The Sale Tax`
  String get pleaseEnterTheSaleTax {
    return Intl.message(
      'Please Enter The Sale Tax',
      name: 'pleaseEnterTheSaleTax',
      desc: '',
      args: [],
    );
  }

  /// `Input`
  String get input {
    return Intl.message(
      'Input',
      name: 'input',
      desc: '',
      args: [],
    );
  }

  /// `Slider To Setting`
  String get sliderToSetting {
    return Intl.message(
      'Slider To Setting',
      name: 'sliderToSetting',
      desc: '',
      args: [],
    );
  }

  /// `Can Not Over`
  String get canNotOver {
    return Intl.message(
      'Can Not Over',
      name: 'canNotOver',
      desc: '',
      args: [],
    );
  }

  /// `Mnemonic`
  String get mnemonic {
    return Intl.message(
      'Mnemonic',
      name: 'mnemonic',
      desc: '',
      args: [],
    );
  }

  /// `Raw Seed`
  String get rawSeed {
    return Intl.message(
      'Raw Seed',
      name: 'rawSeed',
      desc: '',
      args: [],
    );
  }

  /// `Keystore (json)`
  String get keystore {
    return Intl.message(
      'Keystore (json)',
      name: 'keystore',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get create_name {
    return Intl.message(
      'Name',
      name: 'create_name',
      desc: '',
      args: [],
    );
  }

  /// `Name can not be empty`
  String get create_name_error {
    return Intl.message(
      'Name can not be empty',
      name: 'create_name_error',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get create_password {
    return Intl.message(
      'Password',
      name: 'create_password',
      desc: '',
      args: [],
    );
  }

  /// `At least 6 digits and contains numbers and letters`
  String get create_password_error {
    return Intl.message(
      'At least 6 digits and contains numbers and letters',
      name: 'create_password_error',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get create_password2 {
    return Intl.message(
      'Confirm Password',
      name: 'create_password2',
      desc: '',
      args: [],
    );
  }

  /// `Inconsistent passwords`
  String get create_password2_error {
    return Intl.message(
      'Inconsistent passwords',
      name: 'create_password2_error',
      desc: '',
      args: [],
    );
  }

  /// `Backup prompt`
  String get create_warn1 {
    return Intl.message(
      'Backup prompt',
      name: 'create_warn1',
      desc: '',
      args: [],
    );
  }

  /// `Getting a mnemonic equals ownership of a wallet asset`
  String get create_warn2 {
    return Intl.message(
      'Getting a mnemonic equals ownership of a wallet asset',
      name: 'create_warn2',
      desc: '',
      args: [],
    );
  }

  /// `Backup mnemonic`
  String get create_warn3 {
    return Intl.message(
      'Backup mnemonic',
      name: 'create_warn3',
      desc: '',
      args: [],
    );
  }

  /// `Use paper and pen to correctly copy mnemonics`
  String get create_warn4 {
    return Intl.message(
      'Use paper and pen to correctly copy mnemonics',
      name: 'create_warn4',
      desc: '',
      args: [],
    );
  }

  /// `If your phone is lost, stolen or damaged, the mnemonic will restore your assets`
  String get create_warn5 {
    return Intl.message(
      'If your phone is lost, stolen or damaged, the mnemonic will restore your assets',
      name: 'create_warn5',
      desc: '',
      args: [],
    );
  }

  /// `Offline storage`
  String get create_warn6 {
    return Intl.message(
      'Offline storage',
      name: 'create_warn6',
      desc: '',
      args: [],
    );
  }

  /// `Keep it safe to a safe place on the isolated network`
  String get create_warn7 {
    return Intl.message(
      'Keep it safe to a safe place on the isolated network',
      name: 'create_warn7',
      desc: '',
      args: [],
    );
  }

  /// `Do not share and store mnemonics in a networked environment, such as emails, photo albums, social applications`
  String get create_warn8 {
    return Intl.message(
      'Do not share and store mnemonics in a networked environment, such as emails, photo albums, social applications',
      name: 'create_warn8',
      desc: '',
      args: [],
    );
  }

  /// `Do not take screenshots`
  String get create_warn9 {
    return Intl.message(
      'Do not take screenshots',
      name: 'create_warn9',
      desc: '',
      args: [],
    );
  }

  /// `Do not take screenshots, which may be collected by third-party malware, resulting in asset loss`
  String get create_warn10 {
    return Intl.message(
      'Do not take screenshots, which may be collected by third-party malware, resulting in asset loss',
      name: 'create_warn10',
      desc: '',
      args: [],
    );
  }

  /// `Confirm the mnemonic`
  String get backup {
    return Intl.message(
      'Confirm the mnemonic',
      name: 'backup',
      desc: '',
      args: [],
    );
  }

  /// `Please click on the mnemonic in the correct order to confirm that the backup is correct`
  String get backup_confirm {
    return Intl.message(
      'Please click on the mnemonic in the correct order to confirm that the backup is correct',
      name: 'backup_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get backup_reset {
    return Intl.message(
      'Reset',
      name: 'backup_reset',
      desc: '',
      args: [],
    );
  }

  /// `This device does not support key type sr25519, you can select [Advanced Options -> Encrypt Type -> ed25519] to continue.`
  String get backup_error {
    return Intl.message(
      'This device does not support key type sr25519, you can select [Advanced Options -> Encrypt Type -> ed25519] to continue.',
      name: 'backup_error',
      desc: '',
      args: [],
    );
  }

  /// `Source Type`
  String get import_type {
    return Intl.message(
      'Source Type',
      name: 'import_type',
      desc: '',
      args: [],
    );
  }

  /// `Encrypt Type`
  String get import_encrypt {
    return Intl.message(
      'Encrypt Type',
      name: 'import_encrypt',
      desc: '',
      args: [],
    );
  }

  /// `Invalid`
  String get import_invalid {
    return Intl.message(
      'Invalid',
      name: 'import_invalid',
      desc: '',
      args: [],
    );
  }

  /// `account exist, do you want to override the existing account?`
  String get import_duplicate {
    return Intl.message(
      'account exist, do you want to override the existing account?',
      name: 'import_duplicate',
      desc: '',
      args: [],
    );
  }

  /// `Advanced Options`
  String get advanced {
    return Intl.message(
      'Advanced Options',
      name: 'advanced',
      desc: '',
      args: [],
    );
  }

  /// `Secret derivation path`
  String get path {
    return Intl.message(
      'Secret derivation path',
      name: 'path',
      desc: '',
      args: [],
    );
  }

  /// `Observation`
  String get observe {
    return Intl.message(
      'Observation',
      name: 'observe',
      desc: '',
      args: [],
    );
  }

  /// `\nMark this address as observation,\nthen you can select this address\nin account select page, to watch\nit"s assets and actions\n`
  String get observe_brief {
    return Intl.message(
      '\nMark this address as observation,\nthen you can select this address\nin account select page, to watch\nit"s assets and actions\n',
      name: 'observe_brief',
      desc: '',
      args: [],
    );
  }

  /// `For observing only`
  String get observe_tx {
    return Intl.message(
      'For observing only',
      name: 'observe_tx',
      desc: '',
      args: [],
    );
  }

  /// `sign with proxy account`
  String get observe_proxy {
    return Intl.message(
      'sign with proxy account',
      name: 'observe_proxy',
      desc: '',
      args: [],
    );
  }

  /// `\nA recoverable account can\nsend Tx through a proxy account\n`
  String get observe_proxy_brief {
    return Intl.message(
      '\nA recoverable account can\nsend Tx through a proxy account\n',
      name: 'observe_proxy_brief',
      desc: '',
      args: [],
    );
  }

  /// `Invalid proxy account`
  String get observe_proxy_invalid {
    return Intl.message(
      'Invalid proxy account',
      name: 'observe_proxy_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Invalid`
  String get observe_invalid {
    return Intl.message(
      'Invalid',
      name: 'observe_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Account Select`
  String get list {
    return Intl.message(
      'Account Select',
      name: 'list',
      desc: '',
      args: [],
    );
  }

  /// `Transfer`
  String get transfer {
    return Intl.message(
      'Transfer',
      name: 'transfer',
      desc: '',
      args: [],
    );
  }

  /// `Receive`
  String get receive {
    return Intl.message(
      'Receive',
      name: 'receive',
      desc: '',
      args: [],
    );
  }

  /// `Send to Address`
  String get toAddress {
    return Intl.message(
      'Send to Address',
      name: 'toAddress',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Address`
  String get address_error {
    return Intl.message(
      'Invalid Address',
      name: 'address_error',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Invalid amount`
  String get amount_error {
    return Intl.message(
      'Invalid amount',
      name: 'amount_error',
      desc: '',
      args: [],
    );
  }

  /// `Insufficient balance`
  String get amount_low {
    return Intl.message(
      'Insufficient balance',
      name: 'amount_low',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get currency {
    return Intl.message(
      'Currency',
      name: 'currency',
      desc: '',
      args: [],
    );
  }

  /// `Make Transfer`
  String get make {
    return Intl.message(
      'Make Transfer',
      name: 'make',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get balance {
    return Intl.message(
      'Balance',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `Locked`
  String get locked {
    return Intl.message(
      'Locked',
      name: 'locked',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get available {
    return Intl.message(
      'Available',
      name: 'available',
      desc: '',
      args: [],
    );
  }

  /// `Reserved`
  String get reserved {
    return Intl.message(
      'Reserved',
      name: 'reserved',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `In`
  String get in1 {
    return Intl.message(
      'In',
      name: 'in1',
      desc: '',
      args: [],
    );
  }

  /// `Out`
  String get out {
    return Intl.message(
      'Out',
      name: 'out',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `End`
  String get end {
    return Intl.message(
      'End',
      name: 'end',
      desc: '',
      args: [],
    );
  }

  /// `No More Data`
  String get noMore {
    return Intl.message(
      'No More Data',
      name: 'noMore',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get fail {
    return Intl.message(
      'Failed',
      name: 'fail',
      desc: '',
      args: [],
    );
  }

  /// `Value`
  String get value {
    return Intl.message(
      'Value',
      name: 'value',
      desc: '',
      args: [],
    );
  }

  /// `Tip`
  String get tip {
    return Intl.message(
      'Tip',
      name: 'tip',
      desc: '',
      args: [],
    );
  }

  /// `\nAdding a tip to this Tx, paying\nthe block author for greater priority.\n`
  String get tip_tip {
    return Intl.message(
      '\nAdding a tip to this Tx, paying\nthe block author for greater priority.\n',
      name: 'tip_tip',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get from {
    return Intl.message(
      'From',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get to {
    return Intl.message(
      'To',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `Block`
  String get block {
    return Intl.message(
      'Block',
      name: 'block',
      desc: '',
      args: [],
    );
  }

  /// `Event ID`
  String get event {
    return Intl.message(
      'Event ID',
      name: 'event',
      desc: '',
      args: [],
    );
  }

  /// `TxHash`
  String get hash {
    return Intl.message(
      'TxHash',
      name: 'hash',
      desc: '',
      args: [],
    );
  }

  /// `Open in Browser`
  String get polkascan {
    return Intl.message(
      'Open in Browser',
      name: 'polkascan',
      desc: '',
      args: [],
    );
  }

  /// `term progress`
  String get termProgress {
    return Intl.message(
      'term progress',
      name: 'termProgress',
      desc: '',
      args: [],
    );
  }

  /// `seats`
  String get seats {
    return Intl.message(
      'seats',
      name: 'seats',
      desc: '',
      args: [],
    );
  }

  /// `runners up`
  String get runnersUp {
    return Intl.message(
      'runners up',
      name: 'runnersUp',
      desc: '',
      args: [],
    );
  }

  /// `candidates`
  String get candidates {
    return Intl.message(
      'candidates',
      name: 'candidates',
      desc: '',
      args: [],
    );
  }

  /// `backing`
  String get backing {
    return Intl.message(
      'backing',
      name: 'backing',
      desc: '',
      args: [],
    );
  }

  /// `Submit candidacy`
  String get submitCandidacy {
    return Intl.message(
      'Submit candidacy',
      name: 'submitCandidacy',
      desc: '',
      args: [],
    );
  }

  /// `vote`
  String get vote {
    return Intl.message(
      'vote',
      name: 'vote',
      desc: '',
      args: [],
    );
  }

  /// `Submit Account`
  String get submitAccount {
    return Intl.message(
      'Submit Account',
      name: 'submitAccount',
      desc: '',
      args: [],
    );
  }

  /// `Amount voted`
  String get submit_voted {
    return Intl.message(
      'Amount voted',
      name: 'submit_voted',
      desc: '',
      args: [],
    );
  }

  /// `Voting balance`
  String get submit_voting {
    return Intl.message(
      'Voting balance',
      name: 'submit_voting',
      desc: '',
      args: [],
    );
  }

  /// `Selected Candidate`
  String get submit_selected {
    return Intl.message(
      'Selected Candidate',
      name: 'submit_selected',
      desc: '',
      args: [],
    );
  }

  /// `Clear list`
  String get submit_clear {
    return Intl.message(
      'Clear list',
      name: 'submit_clear',
      desc: '',
      args: [],
    );
  }

  /// `Voters`
  String get voters {
    return Intl.message(
      'Voters',
      name: 'voters',
      desc: '',
      args: [],
    );
  }

  /// `proposals`
  String get proposals {
    return Intl.message(
      'proposals',
      name: 'proposals',
      desc: '',
      args: [],
    );
  }

  /// `total`
  String get total {
    return Intl.message(
      'total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `referenda`
  String get referenda {
    return Intl.message(
      'referenda',
      name: 'referenda',
      desc: '',
      args: [],
    );
  }

  /// `launch period`
  String get launchPeriod {
    return Intl.message(
      'launch period',
      name: 'launchPeriod',
      desc: '',
      args: [],
    );
  }

  /// `dispatch queue`
  String get dispatchQueue {
    return Intl.message(
      'dispatch queue',
      name: 'dispatchQueue',
      desc: '',
      args: [],
    );
  }

  /// `external`
  String get external {
    return Intl.message(
      'external',
      name: 'external',
      desc: '',
      args: [],
    );
  }

  /// `Aye`
  String get aye {
    return Intl.message(
      'Aye',
      name: 'aye',
      desc: '',
      args: [],
    );
  }

  /// `Nay`
  String get nay {
    return Intl.message(
      'Nay',
      name: 'nay',
      desc: '',
      args: [],
    );
  }

  /// `Nay turnout`
  String get ayeTurnout {
    return Intl.message(
      'Nay turnout',
      name: 'ayeTurnout',
      desc: '',
      args: [],
    );
  }

  /// `blocks`
  String get blocks {
    return Intl.message(
      'blocks',
      name: 'blocks',
      desc: '',
      args: [],
    );
  }

  /// `remaining`
  String get remaining {
    return Intl.message(
      'remaining',
      name: 'remaining',
      desc: '',
      args: [],
    );
  }

  /// `activate`
  String get activate {
    return Intl.message(
      'activate',
      name: 'activate',
      desc: '',
      args: [],
    );
  }

  /// `proposer`
  String get proposer {
    return Intl.message(
      'proposer',
      name: 'proposer',
      desc: '',
      args: [],
    );
  }

  /// `lock`
  String get lock {
    return Intl.message(
      'lock',
      name: 'lock',
      desc: '',
      args: [],
    );
  }

  /// `seconds`
  String get seconds {
    return Intl.message(
      'seconds',
      name: 'seconds',
      desc: '',
      args: [],
    );
  }

  /// `Second`
  String get second {
    return Intl.message(
      'Second',
      name: 'second',
      desc: '',
      args: [],
    );
  }

  /// `Yes, Aye`
  String get isAye {
    return Intl.message(
      'Yes, Aye',
      name: 'isAye',
      desc: '',
      args: [],
    );
  }

  /// `No, Nay`
  String get isNay {
    return Intl.message(
      'No, Nay',
      name: 'isNay',
      desc: '',
      args: [],
    );
  }

  /// `Vote value`
  String get voteValue {
    return Intl.message(
      'Vote value',
      name: 'voteValue',
      desc: '',
      args: [],
    );
  }

  /// `Submit Account`
  String get submit_account {
    return Intl.message(
      'Submit Account',
      name: 'submit_account',
      desc: '',
      args: [],
    );
  }

  /// `conviction`
  String get conviction {
    return Intl.message(
      'conviction',
      name: 'conviction',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a value`
  String get submit_err_amount {
    return Intl.message(
      'Please enter a value',
      name: 'submit_err_amount',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a number greater than 0 `
  String get submit_err_number {
    return Intl.message(
      'Please enter a number greater than 0 ',
      name: 'submit_err_number',
      desc: '',
      args: [],
    );
  }

  /// `This application lets you view proposals and vote for or against a referendum. Anyone can create a proposal by bonding the minimum deposit for a certain period of time (No. of Blocks).`
  String get democracy_brief {
    return Intl.message(
      'This application lets you view proposals and vote for or against a referendum. Anyone can create a proposal by bonding the minimum deposit for a certain period of time (No. of Blocks).',
      name: 'democracy_brief',
      desc: '',
      args: [],
    );
  }

  /// `Referendums`
  String get democracy_referendum {
    return Intl.message(
      'Referendums',
      name: 'democracy_referendum',
      desc: '',
      args: [],
    );
  }

  /// `Proposals`
  String get democracy_proposal {
    return Intl.message(
      'Proposals',
      name: 'democracy_proposal',
      desc: '',
      args: [],
    );
  }

  /// `This application lets you vote for council members or submit a candidate.`
  String get council_brief {
    return Intl.message(
      'This application lets you vote for council members or submit a candidate.',
      name: 'council_brief',
      desc: '',
      args: [],
    );
  }

  /// `Motions`
  String get council_motions {
    return Intl.message(
      'Motions',
      name: 'council_motions',
      desc: '',
      args: [],
    );
  }

  /// `Motion`
  String get council_motion {
    return Intl.message(
      'Motion',
      name: 'council_motion',
      desc: '',
      args: [],
    );
  }

  /// `This application lets you view and vote to approve or deny treasury spend proposals.`
  String get treasury_brief {
    return Intl.message(
      'This application lets you view and vote to approve or deny treasury spend proposals.',
      name: 'treasury_brief',
      desc: '',
      args: [],
    );
  }

  /// `Proposals`
  String get treasury_proposal {
    return Intl.message(
      'Proposals',
      name: 'treasury_proposal',
      desc: '',
      args: [],
    );
  }

  /// `Tips`
  String get treasury_tip {
    return Intl.message(
      'Tips',
      name: 'treasury_tip',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get treasury_total {
    return Intl.message(
      'Total',
      name: 'treasury_total',
      desc: '',
      args: [],
    );
  }

  /// `Approvals`
  String get treasury_approval {
    return Intl.message(
      'Approvals',
      name: 'treasury_approval',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get treasury_available {
    return Intl.message(
      'Available',
      name: 'treasury_available',
      desc: '',
      args: [],
    );
  }

  /// `Spend Period`
  String get treasury_period {
    return Intl.message(
      'Spend Period',
      name: 'treasury_period',
      desc: '',
      args: [],
    );
  }

  /// `Days`
  String get treasury_day {
    return Intl.message(
      'Days',
      name: 'treasury_day',
      desc: '',
      args: [],
    );
  }

  /// `Value`
  String get treasury_value {
    return Intl.message(
      'Value',
      name: 'treasury_value',
      desc: '',
      args: [],
    );
  }

  /// `Proposer`
  String get treasury_proposer {
    return Intl.message(
      'Proposer',
      name: 'treasury_proposer',
      desc: '',
      args: [],
    );
  }

  /// `Beneficiary`
  String get treasury_beneficiary {
    return Intl.message(
      'Beneficiary',
      name: 'treasury_beneficiary',
      desc: '',
      args: [],
    );
  }

  /// `Submit Proposal`
  String get treasury_submit {
    return Intl.message(
      'Submit Proposal',
      name: 'treasury_submit',
      desc: '',
      args: [],
    );
  }

  /// `Approve Proposal`
  String get treasury_approve {
    return Intl.message(
      'Approve Proposal',
      name: 'treasury_approve',
      desc: '',
      args: [],
    );
  }

  /// `Reject Proposal`
  String get treasury_reject {
    return Intl.message(
      'Reject Proposal',
      name: 'treasury_reject',
      desc: '',
      args: [],
    );
  }

  /// `Send to council`
  String get treasury_send {
    return Intl.message(
      'Send to council',
      name: 'treasury_send',
      desc: '',
      args: [],
    );
  }

  /// `Vote on proposal`
  String get treasury_vote {
    return Intl.message(
      'Vote on proposal',
      name: 'treasury_vote',
      desc: '',
      args: [],
    );
  }

  /// `Report Awesome`
  String get treasury_report {
    return Intl.message(
      'Report Awesome',
      name: 'treasury_report',
      desc: '',
      args: [],
    );
  }

  /// `Create Tip`
  String get treasury_tipNew {
    return Intl.message(
      'Create Tip',
      name: 'treasury_tipNew',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get treasury_closeTip {
    return Intl.message(
      'Close',
      name: 'treasury_closeTip',
      desc: '',
      args: [],
    );
  }

  /// `Endorse`
  String get treasury_endorse {
    return Intl.message(
      'Endorse',
      name: 'treasury_endorse',
      desc: '',
      args: [],
    );
  }

  /// `Retract`
  String get treasury_retract {
    return Intl.message(
      'Retract',
      name: 'treasury_retract',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get treasury_jet {
    return Intl.message(
      'Send',
      name: 'treasury_jet',
      desc: '',
      args: [],
    );
  }

  /// `Finder`
  String get treasury_finder {
    return Intl.message(
      'Finder',
      name: 'treasury_finder',
      desc: '',
      args: [],
    );
  }

  /// `Who`
  String get treasury_who {
    return Intl.message(
      'Who',
      name: 'treasury_who',
      desc: '',
      args: [],
    );
  }

  /// `Bond`
  String get treasury_bond {
    return Intl.message(
      'Bond',
      name: 'treasury_bond',
      desc: '',
      args: [],
    );
  }

  /// `Minimum Bond`
  String get treasury_bond_min {
    return Intl.message(
      'Minimum Bond',
      name: 'treasury_bond_min',
      desc: '',
      args: [],
    );
  }

  /// `Reason`
  String get treasury_reason {
    return Intl.message(
      'Reason',
      name: 'treasury_reason',
      desc: '',
      args: [],
    );
  }

  /// `Tippers`
  String get treasury_tipper {
    return Intl.message(
      'Tippers',
      name: 'treasury_tipper',
      desc: '',
      args: [],
    );
  }

  /// `Members`
  String get member {
    return Intl.message(
      'Members',
      name: 'member',
      desc: '',
      args: [],
    );
  }

  /// `Runners Up`
  String get up {
    return Intl.message(
      'Runners Up',
      name: 'up',
      desc: '',
      args: [],
    );
  }

  /// `Candidates`
  String get candidate {
    return Intl.message(
      'Candidates',
      name: 'candidate',
      desc: '',
      args: [],
    );
  }

  /// `No candidates found`
  String get candidate_empty {
    return Intl.message(
      'No candidates found',
      name: 'candidate_empty',
      desc: '',
      args: [],
    );
  }

  /// `My Votes`
  String get vote_my {
    return Intl.message(
      'My Votes',
      name: 'vote_my',
      desc: '',
      args: [],
    );
  }

  /// `Voters`
  String get vote_voter {
    return Intl.message(
      'Voters',
      name: 'vote_voter',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Votes`
  String get vote_remove {
    return Intl.message(
      'Cancel Votes',
      name: 'vote_remove',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to cancel your votes? This action will removes the lock and returns the bond Tokens.`
  String get vote_remove_confirm {
    return Intl.message(
      'Do you want to cancel your votes? This action will removes the lock and returns the bond Tokens.',
      name: 'vote_remove_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Vote for Candidate`
  String get vote_candidate {
    return Intl.message(
      'Vote for Candidate',
      name: 'vote_candidate',
      desc: '',
      args: [],
    );
  }

  /// `Vote on Proposal`
  String get vote_proposal {
    return Intl.message(
      'Vote on Proposal',
      name: 'vote_proposal',
      desc: '',
      args: [],
    );
  }

  /// `\nThe amount this total can be reduced by \nto change the referendum outcome. \nThis assumes changes to the convictions of \nthe existing votes, with no additional turnout.\n`
  String get vote_change_up {
    return Intl.message(
      '\nThe amount this total can be reduced by \nto change the referendum outcome. \nThis assumes changes to the convictions of \nthe existing votes, with no additional turnout.\n',
      name: 'vote_change_up',
      desc: '',
      args: [],
    );
  }

  /// `\nThe amount this total should be increased \nby to change the referendum outcome. \nThis assumes additional turnout with \nnew votes at 1x conviction.\n`
  String get vote_change_down {
    return Intl.message(
      '\nThe amount this total should be increased \nby to change the referendum outcome. \nThis assumes additional turnout with \nnew votes at 1x conviction.\n',
      name: 'vote_change_down',
      desc: '',
      args: [],
    );
  }

  /// `Voting end`
  String get vote_end {
    return Intl.message(
      'Voting end',
      name: 'vote_end',
      desc: '',
      args: [],
    );
  }

  /// `Proposal`
  String get proposal {
    return Intl.message(
      'Proposal',
      name: 'proposal',
      desc: '',
      args: [],
    );
  }

  /// `Params`
  String get proposal_params {
    return Intl.message(
      'Params',
      name: 'proposal_params',
      desc: '',
      args: [],
    );
  }

  /// `Second`
  String get proposal_second {
    return Intl.message(
      'Second',
      name: 'proposal_second',
      desc: '',
      args: [],
    );
  }

  /// `Seconds`
  String get proposal_seconds {
    return Intl.message(
      'Seconds',
      name: 'proposal_seconds',
      desc: '',
      args: [],
    );
  }

  /// `Remain`
  String get remain {
    return Intl.message(
      'Remain',
      name: 'remain',
      desc: '',
      args: [],
    );
  }

  /// `Passing`
  String get passing_true {
    return Intl.message(
      'Passing',
      name: 'passing_true',
      desc: '',
      args: [],
    );
  }

  /// `Not Passing`
  String get passing_false {
    return Intl.message(
      'Not Passing',
      name: 'passing_false',
      desc: '',
      args: [],
    );
  }

  /// `Aye, I approve`
  String get yes_text {
    return Intl.message(
      'Aye, I approve',
      name: 'yes_text',
      desc: '',
      args: [],
    );
  }

  /// `Nay, I do not approve`
  String get no_text {
    return Intl.message(
      'Nay, I do not approve',
      name: 'no_text',
      desc: '',
      args: [],
    );
  }

  /// `Voted`
  String get voted {
    return Intl.message(
      'Voted',
      name: 'voted',
      desc: '',
      args: [],
    );
  }

  /// `locked for`
  String get lockedFor {
    return Intl.message(
      'locked for',
      name: 'lockedFor',
      desc: '',
      args: [],
    );
  }

  /// `no lockup period(0.1x)`
  String get locked_no {
    return Intl.message(
      'no lockup period(0.1x)',
      name: 'locked_no',
      desc: '',
      args: [],
    );
  }

  /// `days`
  String get day {
    return Intl.message(
      'days',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get title {
    return Intl.message(
      'Profile',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Contact Address`
  String get contact {
    return Intl.message(
      'Contact Address',
      name: 'contact',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get contact_address {
    return Intl.message(
      'Address',
      name: 'contact_address',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get contact_name {
    return Intl.message(
      'Name',
      name: 'contact_name',
      desc: '',
      args: [],
    );
  }

  /// `Memo`
  String get contact_memo {
    return Intl.message(
      'Memo',
      name: 'contact_memo',
      desc: '',
      args: [],
    );
  }

  /// `Name can not be empty`
  String get contact_name_error {
    return Intl.message(
      'Name can not be empty',
      name: 'contact_name_error',
      desc: '',
      args: [],
    );
  }

  /// `Name exist`
  String get contact_name_exist {
    return Intl.message(
      'Name exist',
      name: 'contact_name_exist',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get contact_save {
    return Intl.message(
      'Save',
      name: 'contact_save',
      desc: '',
      args: [],
    );
  }

  /// `Address exist`
  String get contact_exist {
    return Intl.message(
      'Address exist',
      name: 'contact_exist',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get contact_edit {
    return Intl.message(
      'Edit',
      name: 'contact_edit',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get contact_delete {
    return Intl.message(
      'Delete',
      name: 'contact_delete',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this address?`
  String get contact_delete_warn {
    return Intl.message(
      'Are you sure you want to delete this address?',
      name: 'contact_delete_warn',
      desc: '',
      args: [],
    );
  }

  /// `Remote Node`
  String get setting_node {
    return Intl.message(
      'Remote Node',
      name: 'setting_node',
      desc: '',
      args: [],
    );
  }

  /// `Address Prefix`
  String get setting_prefix {
    return Intl.message(
      'Address Prefix',
      name: 'setting_prefix',
      desc: '',
      args: [],
    );
  }

  /// `Available Prefixes`
  String get setting_prefix_list {
    return Intl.message(
      'Available Prefixes',
      name: 'setting_prefix_list',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get setting_lang {
    return Intl.message(
      'Language',
      name: 'setting_lang',
      desc: '',
      args: [],
    );
  }

  /// `Auto Detect`
  String get setting_lang_auto {
    return Intl.message(
      'Auto Detect',
      name: 'setting_lang_auto',
      desc: '',
      args: [],
    );
  }

  /// `Change Name`
  String get name_change {
    return Intl.message(
      'Change Name',
      name: 'name_change',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get pass_change {
    return Intl.message(
      'Change Password',
      name: 'pass_change',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get pass_old {
    return Intl.message(
      'Current Password',
      name: 'pass_old',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get pass_new {
    return Intl.message(
      'New Password',
      name: 'pass_new',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get pass_new2 {
    return Intl.message(
      'Confirm New Password',
      name: 'pass_new2',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get pass_success {
    return Intl.message(
      'Success',
      name: 'pass_success',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully`
  String get pass_success_txt {
    return Intl.message(
      'Password changed successfully',
      name: 'pass_success_txt',
      desc: '',
      args: [],
    );
  }

  /// `Wrong Password`
  String get pass_error {
    return Intl.message(
      'Wrong Password',
      name: 'pass_error',
      desc: '',
      args: [],
    );
  }

  /// `Failed to unlock account, please check password.`
  String get pass_error_txt {
    return Intl.message(
      'Failed to unlock account, please check password.',
      name: 'pass_error_txt',
      desc: '',
      args: [],
    );
  }

  /// `Export Account`
  String get export {
    return Intl.message(
      'Export Account',
      name: 'export',
      desc: '',
      args: [],
    );
  }

  /// `Write these words down on paper. Keep the backup paper safe. These words allows anyone to recover this account and access its funds.`
  String get export_warn {
    return Intl.message(
      'Write these words down on paper. Keep the backup paper safe. These words allows anyone to recover this account and access its funds.',
      name: 'export_warn',
      desc: '',
      args: [],
    );
  }

  /// `Overview`
  String get overview {
    return Intl.message(
      'Overview',
      name: 'overview',
      desc: '',
      args: [],
    );
  }

  /// `Account Actions`
  String get actions {
    return Intl.message(
      'Account Actions',
      name: 'actions',
      desc: '',
      args: [],
    );
  }

  /// `Validators`
  String get validators {
    return Intl.message(
      'Validators',
      name: 'validators',
      desc: '',
      args: [],
    );
  }

  /// `Validator`
  String get validator {
    return Intl.message(
      'Validator',
      name: 'validator',
      desc: '',
      args: [],
    );
  }

  /// `Elected`
  String get elected {
    return Intl.message(
      'Elected',
      name: 'elected',
      desc: '',
      args: [],
    );
  }

  /// `Waiting`
  String get waiting {
    return Intl.message(
      'Waiting',
      name: 'waiting',
      desc: '',
      args: [],
    );
  }

  /// `Nominators`
  String get nominators {
    return Intl.message(
      'Nominators',
      name: 'nominators',
      desc: '',
      args: [],
    );
  }

  /// `Session`
  String get session {
    return Intl.message(
      'Session',
      name: 'session',
      desc: '',
      args: [],
    );
  }

  /// `Era`
  String get era {
    return Intl.message(
      'Era',
      name: 'era',
      desc: '',
      args: [],
    );
  }

  /// `Total Staked`
  String get totalStaked {
    return Intl.message(
      'Total Staked',
      name: 'totalStaked',
      desc: '',
      args: [],
    );
  }

  /// `Stake`
  String get stake {
    return Intl.message(
      'Stake',
      name: 'stake',
      desc: '',
      args: [],
    );
  }

  /// `Staked`
  String get stake_ratio {
    return Intl.message(
      'Staked',
      name: 'stake_ratio',
      desc: '',
      args: [],
    );
  }

  /// `Own`
  String get stake_own {
    return Intl.message(
      'Own',
      name: 'stake_own',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get stake_other {
    return Intl.message(
      'Other',
      name: 'stake_other',
      desc: '',
      args: [],
    );
  }

  /// `Staked`
  String get staked {
    return Intl.message(
      'Staked',
      name: 'staked',
      desc: '',
      args: [],
    );
  }

  /// `Commission`
  String get commission {
    return Intl.message(
      'Commission',
      name: 'commission',
      desc: '',
      args: [],
    );
  }

  /// `Points`
  String get points {
    return Intl.message(
      'Points',
      name: 'points',
      desc: '',
      args: [],
    );
  }

  /// `Judgements`
  String get judgements {
    return Intl.message(
      'Judgements',
      name: 'judgements',
      desc: '',
      args: [],
    );
  }

  /// `Tx history`
  String get txs {
    return Intl.message(
      'Tx history',
      name: 'txs',
      desc: '',
      args: [],
    );
  }

  /// `Reward/Slash`
  String get txs_reward {
    return Intl.message(
      'Reward/Slash',
      name: 'txs_reward',
      desc: '',
      args: [],
    );
  }

  /// `Event`
  String get txs_event {
    return Intl.message(
      'Event',
      name: 'txs_event',
      desc: '',
      args: [],
    );
  }

  /// `Nominations`
  String get nominating {
    return Intl.message(
      'Nominations',
      name: 'nominating',
      desc: '',
      args: [],
    );
  }

  /// `Controller`
  String get controller {
    return Intl.message(
      'Controller',
      name: 'controller',
      desc: '',
      args: [],
    );
  }

  /// `Stash`
  String get stash {
    return Intl.message(
      'Stash',
      name: 'stash',
      desc: '',
      args: [],
    );
  }

  /// `Bonded`
  String get bonded {
    return Intl.message(
      'Bonded',
      name: 'bonded',
      desc: '',
      args: [],
    );
  }

  /// `Action`
  String get action {
    return Intl.message(
      'Action',
      name: 'action',
      desc: '',
      args: [],
    );
  }

  /// `Bond Funds`
  String get action_bond {
    return Intl.message(
      'Bond Funds',
      name: 'action_bond',
      desc: '',
      args: [],
    );
  }

  /// `Bond More`
  String get action_bondExtra {
    return Intl.message(
      'Bond More',
      name: 'action_bondExtra',
      desc: '',
      args: [],
    );
  }

  /// `Adjust Bonded`
  String get action_bondAdjust {
    return Intl.message(
      'Adjust Bonded',
      name: 'action_bondAdjust',
      desc: '',
      args: [],
    );
  }

  /// `Unbond`
  String get action_unbond {
    return Intl.message(
      'Unbond',
      name: 'action_unbond',
      desc: '',
      args: [],
    );
  }

  /// `Redeem Unbonded`
  String get action_redeem {
    return Intl.message(
      'Redeem Unbonded',
      name: 'action_redeem',
      desc: '',
      args: [],
    );
  }

  /// `Payout`
  String get action_payout {
    return Intl.message(
      'Payout',
      name: 'action_payout',
      desc: '',
      args: [],
    );
  }

  /// `Nominate`
  String get action_nominate {
    return Intl.message(
      'Nominate',
      name: 'action_nominate',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get nominate_active {
    return Intl.message(
      'Active',
      name: 'nominate_active',
      desc: '',
      args: [],
    );
  }

  /// `Oversubscribed`
  String get nominate_over {
    return Intl.message(
      'Oversubscribed',
      name: 'nominate_over',
      desc: '',
      args: [],
    );
  }

  /// `Inactive`
  String get nominate_inactive {
    return Intl.message(
      'Inactive',
      name: 'nominate_inactive',
      desc: '',
      args: [],
    );
  }

  /// `Waiting`
  String get nominate_waiting {
    return Intl.message(
      'Waiting',
      name: 'nominate_waiting',
      desc: '',
      args: [],
    );
  }

  /// `You need to bond Tokens before nominating. Go to bonding now?`
  String get action_nominate_bond {
    return Intl.message(
      'You need to bond Tokens before nominating. Go to bonding now?',
      name: 'action_nominate_bond',
      desc: '',
      args: [],
    );
  }

  /// `Set Nominees`
  String get action_nominee {
    return Intl.message(
      'Set Nominees',
      name: 'action_nominee',
      desc: '',
      args: [],
    );
  }

  /// `Stop Nominating`
  String get action_chill {
    return Intl.message(
      'Stop Nominating',
      name: 'action_chill',
      desc: '',
      args: [],
    );
  }

  /// `Reward Type`
  String get action_reward {
    return Intl.message(
      'Reward Type',
      name: 'action_reward',
      desc: '',
      args: [],
    );
  }

  /// `Bonding Preference`
  String get action_setting {
    return Intl.message(
      'Bonding Preference',
      name: 'action_setting',
      desc: '',
      args: [],
    );
  }

  /// `Change Controller`
  String get action_control {
    return Intl.message(
      'Change Controller',
      name: 'action_control',
      desc: '',
      args: [],
    );
  }

  /// `Import `
  String get action_import {
    return Intl.message(
      'Import ',
      name: 'action_import',
      desc: '',
      args: [],
    );
  }

  /// `Use `
  String get action_use {
    return Intl.message(
      'Use ',
      name: 'action_use',
      desc: '',
      args: [],
    );
  }

  /// ` to operate`
  String get action_operate {
    return Intl.message(
      ' to operate',
      name: 'action_operate',
      desc: '',
      args: [],
    );
  }

  /// `Unlocking`
  String get bond_unlocking {
    return Intl.message(
      'Unlocking',
      name: 'bond_unlocking',
      desc: '',
      args: [],
    );
  }

  /// `Reward`
  String get bond_reward {
    return Intl.message(
      'Reward',
      name: 'bond_reward',
      desc: '',
      args: [],
    );
  }

  /// `Redeemable`
  String get bond_redeemable {
    return Intl.message(
      'Redeemable',
      name: 'bond_redeemable',
      desc: '',
      args: [],
    );
  }

  /// `Payouts`
  String get payout {
    return Intl.message(
      'Payouts',
      name: 'payout',
      desc: '',
      args: [],
    );
  }

  /// `Stash account (increase the amount at stake)`
  String get rewardStaked {
    return Intl.message(
      'Stash account (increase the amount at stake)',
      name: 'rewardStaked',
      desc: '',
      args: [],
    );
  }

  /// `Stash account (do not increase the amount at stake)`
  String get rewardStash {
    return Intl.message(
      'Stash account (do not increase the amount at stake)',
      name: 'rewardStash',
      desc: '',
      args: [],
    );
  }

  /// `Controller account (do not increase the amount at stake)`
  String get rewardController {
    return Intl.message(
      'Controller account (do not increase the amount at stake)',
      name: 'rewardController',
      desc: '',
      args: [],
    );
  }

  /// `Reward destination is not changed`
  String get reward_warn {
    return Intl.message(
      'Reward destination is not changed',
      name: 'reward_warn',
      desc: '',
      args: [],
    );
  }

  /// `Retrieving info for all applicable eras, this will take some time.`
  String get reward_tip {
    return Intl.message(
      'Retrieving info for all applicable eras, this will take some time.',
      name: 'reward_tip',
      desc: '',
      args: [],
    );
  }

  /// `Period`
  String get reward_time {
    return Intl.message(
      'Period',
      name: 'reward_time',
      desc: '',
      args: [],
    );
  }

  /// `Max`
  String get reward_max {
    return Intl.message(
      'Max',
      name: 'reward_max',
      desc: '',
      args: [],
    );
  }

  /// `Sender`
  String get reward_sender {
    return Intl.message(
      'Sender',
      name: 'reward_sender',
      desc: '',
      args: [],
    );
  }

  /// `Unavailable, stash account of `
  String get controllerStashOf {
    return Intl.message(
      'Unavailable, stash account of ',
      name: 'controllerStashOf',
      desc: '',
      args: [],
    );
  }

  /// `Unavailable, controller account of `
  String get controllerControllerOf {
    return Intl.message(
      'Unavailable, controller account of ',
      name: 'controllerControllerOf',
      desc: '',
      args: [],
    );
  }

  /// `Controller account is not changed`
  String get controllerWarn {
    return Intl.message(
      'Controller account is not changed',
      name: 'controllerWarn',
      desc: '',
      args: [],
    );
  }

  /// `Filter with Address/Name`
  String get filter {
    return Intl.message(
      'Filter with Address/Name',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Sort by`
  String get sort {
    return Intl.message(
      'Sort by',
      name: 'sort',
      desc: '',
      args: [],
    );
  }

  /// `Recommended`
  String get recommendNode {
    return Intl.message(
      'Recommended',
      name: 'recommendNode',
      desc: '',
      args: [],
    );
  }

  /// `Approved`
  String get approved {
    return Intl.message(
      'Approved',
      name: 'approved',
      desc: '',
      args: [],
    );
  }

  /// `Spend period`
  String get spendPeriod {
    return Intl.message(
      'Spend period',
      name: 'spendPeriod',
      desc: '',
      args: [],
    );
  }

  /// `days`
  String get days {
    return Intl.message(
      'days',
      name: 'days',
      desc: '',
      args: [],
    );
  }

  /// `No pending proposals`
  String get noPendingProposals {
    return Intl.message(
      'No pending proposals',
      name: 'noPendingProposals',
      desc: '',
      args: [],
    );
  }

  /// `No approved proposals`
  String get noApprovedProposals {
    return Intl.message(
      'No approved proposals',
      name: 'noApprovedProposals',
      desc: '',
      args: [],
    );
  }

  /// `No pending tips`
  String get noPendingTips {
    return Intl.message(
      'No pending tips',
      name: 'noPendingTips',
      desc: '',
      args: [],
    );
  }

  /// `Beneficiary`
  String get beneficiary {
    return Intl.message(
      'Beneficiary',
      name: 'beneficiary',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get payment {
    return Intl.message(
      'Payment',
      name: 'payment',
      desc: '',
      args: [],
    );
  }

  /// `Bond`
  String get bond {
    return Intl.message(
      'Bond',
      name: 'bond',
      desc: '',
      args: [],
    );
  }

  /// `Finder`
  String get finder {
    return Intl.message(
      'Finder',
      name: 'finder',
      desc: '',
      args: [],
    );
  }

  /// `Reason`
  String get reason {
    return Intl.message(
      'Reason',
      name: 'reason',
      desc: '',
      args: [],
    );
  }

  /// `Endorsements`
  String get endorsements {
    return Intl.message(
      'Endorsements',
      name: 'endorsements',
      desc: '',
      args: [],
    );
  }

  /// `Endorse`
  String get endorse {
    return Intl.message(
      'Endorse',
      name: 'endorse',
      desc: '',
      args: [],
    );
  }

  /// `Submit proposal`
  String get submitProposal {
    return Intl.message(
      'Submit proposal',
      name: 'submitProposal',
      desc: '',
      args: [],
    );
  }

  /// `submit with account`
  String get submitWithAccount {
    return Intl.message(
      'submit with account',
      name: 'submitWithAccount',
      desc: '',
      args: [],
    );
  }

  /// `This account will make the proposal and be responsible for the bond.`
  String get submitWithAccountTip {
    return Intl.message(
      'This account will make the proposal and be responsible for the bond.',
      name: 'submitWithAccountTip',
      desc: '',
      args: [],
    );
  }

  /// `The beneficiary will receive the full amount if the proposal passes.`
  String get beneficiaryTip {
    return Intl.message(
      'The beneficiary will receive the full amount if the proposal passes.',
      name: 'beneficiaryTip',
      desc: '',
      args: [],
    );
  }

  /// `The value is the amount that is being asked for and that will be allocated to the beneficiary if the proposal is approved.`
  String get valueTip {
    return Intl.message(
      'The value is the amount that is being asked for and that will be allocated to the beneficiary if the proposal is approved.',
      name: 'valueTip',
      desc: '',
      args: [],
    );
  }

  /// `proposal bond`
  String get proposalBond {
    return Intl.message(
      'proposal bond',
      name: 'proposalBond',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

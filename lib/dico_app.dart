import 'dart:async';

import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/pages/dao/application_motion.dart';
import 'package:dicolite/pages/dao/dao_vote.dart';
import 'package:dicolite/pages/ico/add_ico.dart';
import 'package:dicolite/pages/ico/ico_participate.dart';
import 'package:dicolite/pages/ico/manage/ico_manage.dart';
import 'package:dicolite/pages/ico/manage/ico_pending.dart';
import 'package:dicolite/pages/ico/manage/ico_request_release.dart';
import 'package:dicolite/pages/ico/manage/ico_set_min_max_amount.dart';
import 'package:dicolite/pages/ico/manage/ico_set_usermax_times.dart';
import 'package:dicolite/pages/ico/select_mult_area.dart';
import 'package:dicolite/pages/lbp/add_lbp.dart';
import 'package:dicolite/pages/lbp/lbp_exchange.dart';
import 'package:dicolite/pages/lbp/lbp_detail.dart';
import 'package:dicolite/pages/lbp/manage_lbp.dart';
import 'package:dicolite/pages/me/find_token.dart';
import 'package:dicolite/pages/me/kyc/add_kyc.dart';
import 'package:dicolite/pages/me/kyc/audit/kyc_ias_audit.dart';
import 'package:dicolite/pages/me/kyc/audit/kyc_ias_audit_list.dart';
import 'package:dicolite/pages/me/kyc/audit/kyc_sword_holder_audit.dart';
import 'package:dicolite/pages/me/kyc/audit/kyc_sword_holder_audit_list.dart';
import 'package:dicolite/pages/me/kyc/certification.dart';
import 'package:dicolite/pages/me/kyc/kyc.dart';
import 'package:dicolite/pages/me/kyc/request_judgement.dart';
import 'package:dicolite/pages/me/nft/buy_nft.dart';
import 'package:dicolite/pages/me/nft/claim_nft.dart';
import 'package:dicolite/pages/me/nft/my_nft.dart';
import 'package:dicolite/pages/me/nft/nft.dart';
import 'package:dicolite/pages/me/nft/sell_nft.dart';
import 'package:dicolite/pages/me/nft/transfer_nft.dart';
import 'package:dicolite/pages/swap/farms/farm.dart';
import 'package:dicolite/pages/swap/pools/add_pool.dart';
import 'package:dicolite/pages/swap/select_token.dart';
import 'package:dicolite/service/check_version.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/pages/home.dart';
import 'package:dicolite/pages/me/address_qr.dart';
import 'package:dicolite/pages/me/contacts/contact_list_page.dart';
import 'package:dicolite/pages/me/contacts/contact_page.dart';
import 'package:dicolite/pages/me/contacts/contacts_page.dart';
import 'package:dicolite/pages/me/council/candidateDetailPage.dart';
import 'package:dicolite/pages/me/council/candidateListPage.dart';
import 'package:dicolite/pages/me/assets/asset.dart';
import 'package:dicolite/pages/me/assets/transfer/transfer_detail.dart';
import 'package:dicolite/pages/me/council/councilPage.dart';
import 'package:dicolite/pages/me/council/councilVotePage.dart';
import 'package:dicolite/pages/me/council/motionDetailPage.dart';
import 'package:dicolite/pages/me/create_account/create/backup_account.dart';
import 'package:dicolite/pages/me/create_account/create/create_account.dart';
import 'package:dicolite/pages/me/create_account/create_account_entry.dart';
import 'package:dicolite/pages/me/create_account/import/import_account.dart';
import 'package:dicolite/pages/me/democracy/democracyPage.dart';
import 'package:dicolite/pages/me/democracy/proposalDetailPage.dart';
import 'package:dicolite/pages/me/democracy/referendumVotePage.dart';
import 'package:dicolite/pages/me/manage_account/change_name.dart';
import 'package:dicolite/pages/me/manage_account/change_password.dart';
import 'package:dicolite/pages/me/manage_account/export_account.dart';
import 'package:dicolite/pages/me/manage_account/export_result.dart';
import 'package:dicolite/pages/me/manage_account/manage_account.dart';

import 'package:dicolite/pages/me/scan_page.dart';
import 'package:dicolite/pages/me/select_account.dart';
import 'package:dicolite/pages/me/setting/about.dart';
import 'package:dicolite/pages/me/setting/custom_types.dart';
import 'package:dicolite/pages/me/setting/set_node/add_node.dart';
import 'package:dicolite/pages/me/setting/set_node/set_node.dart';
import 'package:dicolite/pages/me/setting/setting.dart';
import 'package:dicolite/pages/me/treasury/spendProposalPage.dart';
import 'package:dicolite/pages/me/treasury/submitProposalPage.dart';
import 'package:dicolite/pages/me/treasury/submitTipPage.dart';
import 'package:dicolite/pages/me/treasury/tipDetailPage.dart';
import 'package:dicolite/pages/me/treasury/treasuryPage.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:overlay_support/overlay_support.dart';

import 'pages/me/assets/token_asset.dart';
import 'pages/me/assets/transfer/transfer.dart';

import 'common/theme.dart';
import 'pages/swap/pools/pool.dart';

class DicoApp extends StatefulWidget {
  const DicoApp();

  @override
  _DicoAppState createState() => _DicoAppState();
}

class _DicoAppState extends State<DicoApp> {
  AppStore? _appStore;
  Locale _locale = const Locale('en', '');

  void _changeLang(BuildContext context, String code) {
    Locale res;
    switch (code) {
      case 'en':
        res = const Locale('en', '');
        break;
      default:
        res = Localizations.localeOf(context);
    }
    setState(() {
      _locale = res;
    });
    S.load(_locale);
  }

  void _changeTheme() {}

  Future<int> _initStore(BuildContext context) async {
    if (_appStore == null) {
      _appStore = globalAppStore;
      print('initailizing app state');
      await _appStore!.init(Localizations.localeOf(context).toString());

      // init webApi after store initiated
      webApi = Api(context, _appStore!);
      webApi!.init();

      // _changeLang(context, _appStore!.settings!.localeCode);

      ///Get new version info
      CheckVersion().getNewVersion(context, _locale.languageCode);

     
    }
    return _appStore!.account!.accountList.length;
  }

  @override
  void dispose() async {
  
    webApi!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', ''),
          ],
          initialRoute: Home.route,
          theme: AppTheme.getThemeData(),
          routes: {
            Home.route: (context) => Observer(
                  builder: (_) {
                    return FutureBuilder<int>(
                      future: _initStore(context),
                      builder: (_, AsyncSnapshot<int> snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data! > 0
                              ? Home(_appStore!)
                              : CreateAccountEntryPage();
                        } else {
                          return Scaffold(
                            body: Center(child: LoadingWidget()),
                          );
                        }
                      },
                    );
                  },
                ),

            CreateAccountEntryPage.route: (_) => CreateAccountEntryPage(),

            ///ico
            AddIco.route: (_) => AddIco(_appStore!),
            IcoParticipate.route: (_) => IcoParticipate(_appStore!),
            IcoManage.route: (_) => IcoManage(_appStore!),
            SelectMultArea.route: (_) => SelectMultArea(),
            IcoSetMinMaxAmount.route: (_) => IcoSetMinMaxAmount(_appStore!),
            IcoSetUsermaxTimes.route: (_) => IcoSetUsermaxTimes(_appStore!),
            IcoRequestRelease.route: (_) => IcoRequestRelease(_appStore!),
            IcoPending.route: (_) => IcoPending(_appStore!),

            //dao
            ApplicationMotion.route: (_) => ApplicationMotion(_appStore!),
            DaoVote.route: (_) => DaoVote(_appStore!),

            //lbp
            AddLbp.route: (_) => AddLbp(_appStore!),
            ManageLbp.route: (_) => ManageLbp(_appStore!),
            LbpExchange.route: (_) => LbpExchange(_appStore!),
            LbpDetail.route: (_) => LbpDetail(_appStore!),

            //swap
            SelectToken.route: (_) => SelectToken(_appStore!),
            Farm.route: (_) => Farm(_appStore!),
            Pool.route: (_) => Pool(_appStore!),
            AddPool.route: (_) => AddPool(_appStore!),

            // kyc
            Kyc.route: (_) => Kyc(_appStore!),
            AddKyc.route: (_) => AddKyc(_appStore!),
            Certification.route: (_) => Certification(_appStore!),
            RequestJudgement.route: (_) => RequestJudgement(_appStore!),
            KycIasAudit.route: (_) => KycIasAudit(_appStore!),
            KycSwordHolderAudit.route: (_) => KycSwordHolderAudit(_appStore!),
            KycIasAuditList.route: (_) => KycIasAuditList(_appStore!),
            KycSwordHolderAuditList.route: (_) =>
                KycSwordHolderAuditList(_appStore!),

            // nft
            Nft.route: (_) => Nft(_appStore!),
            MyNft.route: (_) => MyNft(_appStore!),
            ClaimNft.route: (_) => ClaimNft(_appStore!),
            TransferNft.route: (_) => TransferNft(_appStore!),
            SellNft.route: (_) => SellNft(_appStore!),
            BuyNft.route: (_) => BuyNft(_appStore!),

            // governance
            DemocracyPage.route: (_) => DemocracyPage(_appStore!),
            CouncilPage.route: (_) => CouncilPage(_appStore!),
            MotionDetailPage.route: (_) => MotionDetailPage(_appStore!),
            TreasuryPage.route: (_) => TreasuryPage(_appStore!),
            SpendProposalPage.route: (_) => SpendProposalPage(_appStore!),
            TipDetailPage.route: (_) => TipDetailPage(_appStore!),
            SubmitProposalPage.route: (_) => SubmitProposalPage(_appStore!),
            SubmitTipPage.route: (_) => SubmitTipPage(_appStore!),
            CandidateDetailPage.route: (_) => CandidateDetailPage(_appStore!),
            CouncilVotePage.route: (_) => CouncilVotePage(_appStore!),
            CandidateListPage.route: (_) => CandidateListPage(_appStore!),
            ReferendumVotePage.route: (_) => ReferendumVotePage(_appStore!),
            ProposalDetailPage.route: (_) => ProposalDetailPage(_appStore!),

            /// create account
            CreateAccountEntryPage.route: (_) => CreateAccountEntryPage(),
            CreateAccountPage.route: (_) =>
                CreateAccountPage(_appStore!.account!.setNewAccount),
            BackupAccountPage.route: (_) => BackupAccountPage(_appStore!),
            ImportAccountPage.route: (_) => ImportAccountPage(_appStore!),

            /// contact
            ContactListPage.route: (_) => ContactListPage(_appStore!),
            ContactPage.route: (_) => ContactPage(_appStore!),
            ContactsPage.route: (_) => ContactsPage(_appStore!.settings!),

            /// my
            SelectAccount.route: (_) => SelectAccount(_appStore!, _changeTheme),
            FindToken.route: (_) => FindToken(_appStore!),

            AddressQR.route: (_) => AddressQR(_appStore!),
            ScanPage.route: (_) => ScanPage(),

            ChangeName.route: (_) => ChangeName(_appStore!.account!),
            ChangePassword.route: (_) => ChangePassword(_appStore!.account!),
            ExportAccount.route: (_) => ExportAccount(_appStore!.account!),
            ExportResult.route: (_) => ExportResult(),
            ManageAccount.route: (_) => ManageAccount(_appStore!),

            Setting.route: (_) => Setting(_appStore!, _changeLang),

            SetNode.route: (_) => SetNode(_appStore!.settings!),
            CustomTypes.route: (_) => CustomTypes(_appStore!),
            AddNode.route: (_) => AddNode(_appStore!.settings!),
            About.route: (_) => About(),

            TxConfirmPage.route: (_) => TxConfirmPage(_appStore!),
            Asset.route: (_) => Asset(_appStore!),
            TokenAsset.route: (_) => TokenAsset(_appStore!),
            TransferPage.route: (_) => TransferPage(_appStore!),
            TransferDetailPage.route: (_) => TransferDetailPage(_appStore!),
          }),
    );
  }
}

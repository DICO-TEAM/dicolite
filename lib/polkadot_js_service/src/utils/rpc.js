export default 

{
  farm: {
    getParticipantReward: {
      description: 'getParticipantReward',
      params: [
        {
          name: 'account',
          type: 'AccountId'
        },
        {
          name: 'pid',
          type: 'u32'
        },
      ],
      type: 'Balance'
    },
  },
  ico: {
    getTokenPrice: {
      description: 'getTokenPrice',
      params: [
        {
          name: 'currencyId',
          type: 'u32'
        }
      ],
      type: 'Balance'
    },
    canReleaseAmount: {
      description: 'canReleaseAmount',
      params: [
        {
          name: 'account',
          type: 'AccountId'
        },
        {
          name: 'currencyId',
          type: 'u32'
        },
        {
          name: 'index',
          type: 'u32'
        },
      ],
      type: 'Balance'
    },
    canUnlockAmount: {
      description: 'canUnlockAmount',
      params: [
        {
          name: 'account',
          type: 'AccountId'
        },
        {
          name: 'currencyId',
          type: 'u32'
        },
        {
          name: 'index',
          type: 'u32'
        },
      ],
      type: 'Balance'
    },
    getRewardAmount: {
      description: 'getRewardAmount',
      params: [
        {
          name: 'account',
          type: 'AccountId'
        },
        {
          name: 'currencyId',
          type: 'u32'
        },
        {
          name: 'index',
          type: 'u32'
        },
      ],
      type: 'Balance'
    },
    canJoinAmount: {
      description: 'canJoinAmount',
      params: [
        {
          name: 'user',
          type: 'AccountId'
        },
        {
          name: 'currencyId',
          type: 'u32'
        },
        {
          name: 'index',
          type: 'u32'
        },
      ],
      type: '(Balance,Balance)'
    },
  }
}
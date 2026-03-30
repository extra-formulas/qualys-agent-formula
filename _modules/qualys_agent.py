#python
"""Qualys agent execution module.
This module implements the execution actions related to the Qualys agent.

Version: 0.0.1

TODO:
- everything

Refs:
"""

import logging

LOGGER = logging.getLogger(__name__)

def register(path_to_qualys_cloud_agent_sh, activation_id, customer_id):
	"""Register the agent
	Executes the command recommended by Qualys to register the cloud agent.
	"""
	
	command_str = '{} ActivationId={} CustomerId={}'.format(path_to_qualys_cloud_agent_sh, activation_id, customer_id)
	LOGGER.debug('Registering Qualys agent with: %s', command_str)
	result = __salt__['cmd.run'](command_str)
	return result
